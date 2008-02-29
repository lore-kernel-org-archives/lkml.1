Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbYB2TkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbYB2TkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932861AbYB2Tjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:39:55 -0500
Received: from the.earth.li ([217.147.81.2]:47486 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602AbYB2Tjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:39:53 -0500
Date: Fri, 29 Feb 2008 19:39:51 +0000
From: Simon Huggins <huggie@earth.li>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080229193951.GI24533@paranoidfreak.co.uk>
References: <20080229115256.GG24533@paranoidfreak.co.uk> <20080229133433.GA15532@elte.hu> <20080229135137.GA23781@elte.hu> <20080229140024.GA26342@elte.hu> <20080229115256.GG24533@paranoidfreak.co.uk> <20080229133433.GA15532@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <20080229140024.GA26342@elte.hu> <20080229133433.GA15532@elte.hu>
X-Attribution: huggie
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ingo,

(please cc me again)

On Fri, Feb 29, 2008 at 02:34:33PM +0100, Ingo Molnar wrote:
> * Simon Huggins <huggie@earth.li> wrote:
> > [ Please Cc me on replies ]
> > I had a bug with sdhci which Pierre Ossman looked at for me.
> > In the end essentially the fix was to use HZ=1000 and nothing else. 
> > Pierre seemed to think that this was a bug in the scheduler.
> does the patch below help, even if you keep HZ=100? This doesnt look 
> like a scheduler issue, it's more of a timer/timing issue. Different HZ 
> means different msleep() results - and the mmc code does a loop of small 
> msleep delays.

Thanks for looking at it.

I did tests with 2.6.24.3 with HZ=1000 and HZ=100 and as expected the
latter didn't work.

> -------------->
> ---
>  drivers/mmc/core/core.h |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

> Index: linux/drivers/mmc/core/core.h
> ===================================================================
> --- linux.orig/drivers/mmc/core/core.h
> +++ linux/drivers/mmc/core/core.h
> @@ -36,12 +36,7 @@ void mmc_set_timing(struct mmc_host *hos

>  static inline void mmc_delay(unsigned int ms)
>  {
> -	if (ms < 1000 / HZ) {
> -		cond_resched();
> -		mdelay(ms);
> -	} else {
> -		msleep(ms);
> -	}
> +	mdelay(ms);
>  }

>  void mmc_rescan(struct work_struct *work);

That doesn't work.  I did a test with HZ=100 and this patch.  I've
attached the log as patch1-log.

On Fri, Feb 29, 2008 at 03:00:24PM +0100, Ingo Molnar wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:

> > alternatively, instead of applying the first patch, could you apply 
> > the patch below instead? This makes "msleep()" much more precise. Does 
> > this help in the HZ != 1000 case?

> ok, this had a build failure - use the one below instead.

That doesn't work either.  Again I did a test with HZ=100 and this
patch.  I've attached the log as patch2-log.

It had some fuzz but no rejects with 2.6.24.3.

> -------------->
> Subject: hrtimers: use hrtimers so that msleep() sleeps for the requested time
> From: Jonathan Corbet <corbet@lwn.net>

> The problem being addressed here is that the current msleep() will stop
> for a minimum of two jiffies, meaning that, on a HZ=100 system,
> msleep(1) delays for for about 20ms.  In a driver with one such delay
> for each of 150 or so register setting operations, the extra time adds
> up to a few seconds.

> This patch addresses the situation by using hrtimers.  On tickless
> systems with working timers, msleep(1) now sleeps for 1ms, even with
> HZ=100.

> Most comments last time were favorable.  The one dissenter was Roman,
> who worries about the overhead of using hrtimers for this operation; my
> understanding is that he would rather see a really_msleep() function for
> those who actually want millisecond resolution.  I'm not sure how to
> characterize what the cost could be, but it can only be buried by the
> fact that every call sleeps for some number of milliseconds.  On my
> system, the several hundred total msleep() calls can't cause any real
> overhead, and almost all happen at initialization time.

> I still think it would be useful for msleep() to do what it says it does
> and not vastly oversleep with small arguments.  A quick grep turns up
> 450 msleep(1) calls in the current mainline.  Andrew, if you agree, can
> you drop this into -mm?  If not, I guess I'll let it go.

> Current msleep() snoozes for at least two jiffies, causing msleep(1) to
> sleep for at least 20ms on HZ=100 systems.  Using hrtimers allows
> msleep() to sleep for something much closer to the requested time.

[snip]


Anything else I can try?

-- 
----------(  "There are times when I think Clint belongs in  )----------
----------( my RSS-hole" -- anonymous Debian Planet reader.  )----------
Simon ----(                                                  )---- Nomis
                             Htag.pl 0.0.22

--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch1-log

[   15.052986] sdhci: SDHCI controller found at 0000:03:0b.3 [104c:803c] (rev 0)
[   15.053077] sdhci [sdhci_probe()]: found 1 slot(s)
[   15.053102] PCI: Enabling device 0000:03:0b.3 (0000 -> 0002)
[   15.053186] ACPI: PCI Interrupt 0000:03:0b.3[D] -> GSI 23 (level, low) -> IRQ 23
[   15.053340] sdhci [sdhci_probe_slot()]: slot 0 at 0x88089800, irq 23
[   15.054103] sdhci: ============== REGISTER DUMP ==============
[   15.054110] sdhci: Sys addr: 0x00000000 | Version:  0x00008900
[   15.054115] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[   15.054120] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[   15.054125] sdhci: Present:  0x000a0000 | Host ctl: 0x00000000
[   15.054129] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[   15.054134] sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
[   15.054139] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[   15.054144] sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
[   15.054149] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[   15.054154] sdhci: Caps:     0x01e030b0 | Max curr: 0x00000000
[   15.054156] sdhci: ===========================================
[   15.054207] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   15.054222] mmc0: SDHCI at 0x88089800 irq 23 DMA
[   15.054958] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[   15.055137] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   15.055883] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   15.056000] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   15.058006] mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   15.061014] mmc0: clock 187500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   15.062020] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   15.062207] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[   15.062350] PCI: Enabling device 0000:00:1b.0 (0000 -> 0002)
[   15.062443] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   15.063326] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   15.064359] mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   15.065366] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   15.065403] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[   15.065408] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   15.065441] mmc0: req failed (CMD5): -123, retrying...
[   15.065475] mmc0: req failed (CMD5): -123, retrying...
[   15.065498] mmc0: req failed (CMD5): -123, retrying...
[   15.065528] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[   15.065533] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   15.065557] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   15.065561] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   15.065591] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   15.065596] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   15.065620] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   15.065625] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   15.065654] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   15.065659] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   15.065680] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[   15.065685] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0



[   33.923911] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000040
[   33.936455] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   33.938471] mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   33.941487] mmc0: clock 187500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   33.942495] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   33.942761] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
[   33.942774] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   33.943965] mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   33.944976] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   33.945148] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.945163] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
[   33.945341] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   33.945585] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.945602] mmc0: req failed (CMD5): -110, retrying...
[   33.946582] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.946595] mmc0: req failed (CMD5): -110, retrying...
[   33.947572] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.947584] mmc0: req failed (CMD5): -110, retrying...
[   33.947864] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.947878] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
[   33.947952] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   33.948936] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.948949] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   33.949025] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   33.950006] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.950018] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   33.950092] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   33.950349] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.950363] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   33.950435] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   33.951416] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.951429] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   33.951505] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   33.952486] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   33.952499] mmc0: req done (CMD1): -110: 00000000 00000000 00000000 00000000
[   33.952573] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0

--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch2-log

[   18.258572] sdhci [sdhci_probe_slot()]: slot 0 at 0x88089800, irq 23
[   18.259443] sdhci: ============== REGISTER DUMP ==============
[   18.259451] sdhci: Sys addr: 0x00000000 | Version:  0x00008900
[   18.259456] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[   18.259461] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[   18.259466] sdhci: Present:  0x000a0000 | Host ctl: 0x00000000
[   18.259471] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[   18.259476] sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
[   18.259481] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[   18.259486] sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
[   18.259490] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[   18.259495] sdhci: Caps:     0x01e030b0 | Max curr: 0x00000000
[   18.259498] sdhci: ===========================================
[   18.259548] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   18.259564] mmc0: SDHCI at 0x88089800 irq 23 DMA
[   18.259820] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   18.261828] mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   18.262095] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[   18.262274] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   18.263735] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   18.265293] mmc0: clock 187500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   18.266300] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   18.266319] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[   18.266477] PCI: Enabling device 0000:00:1b.0 (0000 -> 0002)
[   18.266570] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   18.267476] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   18.268512] mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   18.269521] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   18.269536] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[   18.269542] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   18.269554] mmc0: req failed (CMD5): -123, retrying...
[   18.269564] mmc0: req failed (CMD5): -123, retrying...
[   18.269574] mmc0: req failed (CMD5): -123, retrying...
[   18.269585] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[   18.269590] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   18.269601] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   18.269606] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   18.269617] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   18.269622] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   18.269634] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   18.269639] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   18.269650] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[   18.269655] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   18.269667] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[   18.269672] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0




[   43.040586] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000040
[   43.050979] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   43.052997] mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   43.056012] mmc0: clock 187500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   43.057021] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   43.057241] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
[   43.057254] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   43.058443] mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   43.059454] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   43.059624] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.059638] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
[   43.059830] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   43.060076] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.060090] mmc0: req failed (CMD5): -110, retrying...
[   43.060428] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.060451] mmc0: req failed (CMD5): -110, retrying...
[   43.061426] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.061443] mmc0: req failed (CMD5): -110, retrying...
[   43.062415] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.062431] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
[   43.062472] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   43.062777] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.062792] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   43.062804] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   43.063182] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.063207] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   43.063222] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   43.064209] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.064226] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   43.064237] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   43.065207] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.065222] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 00000000
[   43.065261] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   43.065596] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
[   43.065612] mmc0: req done (CMD1): -110: 00000000 00000000 00000000 00000000
[   43.065625] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0

--tMbDGjvJuJijemkf--
