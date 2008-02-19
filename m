Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbYBSLYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbYBSLYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYBSLXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:23:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45905 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760149AbYBSLW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:22:59 -0500
Date: Tue, 19 Feb 2008 10:20:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
Message-ID: <20080219092042.GA1374@elf.ucw.cz>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz> <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 2008-02-18 16:12:40, Thomas Gleixner wrote:
> On Mon, 18 Feb 2008, Pavel Machek wrote:
> > > I do not understand, what you mean. When exactly is "sleeppy test"
> > > running ?
> > 
> > from late_initcall().
> 
> Has the system already switched to highres/nohz mode at this point ?

I guess so, as nohz=off makes the problem go away.

> > > Also the TSC unstable detection is in a 500ms timeframe, so you should
> > > never get a 10s delay.
> > 
> > I'd not expect TSC instability detection to be ran while system is
> > suspending
> 
> There is nothing which switches it off, except right at the point
> where the machine is shutdown. It's definitely active during the
> freeze period.
> 
> > , plus "wrong for 500msec" is still wrong.
> 
> To be wrong for 500ms, the TSC must freeze completely.

...which is still very possible with C3, and being wrong for <500msec
is still wrong.

> > > > I believe fix is very simple:
> > > 
> > > NAK. 
> > > 
> > > This kills TSC on machines which have a working TSC and never go into
> > > suspend.
> > 
> > Apart from OLPC, which machines have working TSC?
> > 
> > Anything that has cpufreq does not.
> 
> Wrong. Newer CPUs have TSCs which are not affected by cpu frequency.

Ok, so whitelist the newer CPUs.

> > Anything that enters C2 does not.
> 
> Wrong. C3 stops the TSC everywhere. C2 should not, but it does
> unfortunately due to stupid BIOS implementations and on a lot of AMD
> CPUs.

Hmm, and C3 is rather common, right?

> > Anything that is SMP does not.
> 
> Wrong. I'm writing this mail from a SMP machine with perfectly
> sychronized TSCs.

While I'm writing this from thinkpad X60:

checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 580063 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.

> > So, how many machines do you have with working TSC?
> 
> At least 5.

Out of?

I do not see what we are arguing about. TSC was not originally
designed to provide time, and it does not provide time at least on
machines with C3. We are using it by default, which is just wrong.

If it works for some systems, they should be whitelisted.

> One sensible solution would be to force TSC unstable before we
> suspend, but I'd like to know why that 10sec delay happens at all.
> 
> Can you please provide a dmesg log ?

(Detailed log in attachment).

...
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_throughput
PM: test RTC wakeup from 'mem' suspend
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
ACPI: Preparing to enter system sleep state S3
coretemp coretemp.0: suspend
serio serio1: suspend
serio_suspend: starting
serio_suspend: done
atkbd serio0: suspend
serio_suspend: starting
ps2_command enter
ps2_command get mutex
ps2_command pause rx
ps2_command synaptics
ps2_command sending bytes
ps2_command waiting event: 1000
wait_event returned: 998
ps2_command adjust timeout: 25
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# here it hangs, for ~30 seconds, while it should be sleeping for 100msec.
#
ps2_command receiving
ps2_command mostly done
serio_suspend: done
i8042 i8042: suspend
i8042_suspend: starting
i8042_suspend: done
sd 0:0:0:0: suspend
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
sd 0:0:0:0: suspended
ahci: autosuspend disabled

Here's what I used to get those debug prints:

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 2763394..8115893 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -895,12 +895,14 @@ #ifdef CONFIG_PM
 
 static int i8042_suspend(struct platform_device *dev, pm_message_t state)
 {
+	printk("i8042_suspend: starting\n");
 	if (dev->dev.power.power_state.event != state.event) {
 		if (state.event == PM_EVENT_SUSPEND)
 			i8042_controller_reset();
 
 		dev->dev.power.power_state = state;
 	}
+	printk("i8042_suspend: done\n");
 
 	return 0;
 }
diff --git a/drivers/input/serio/libps2.c b/drivers/input/serio/libps2.c
index b819239..81bd843 100644
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -178,6 +178,7 @@ int ps2_command(struct ps2dev *ps2dev, u
 	int rc = -1;
 	int i;
 
+	printk("ps2_command enter\n");
 	if (receive > sizeof(ps2dev->cmdbuf)) {
 		WARN_ON(1);
 		return -1;
@@ -188,8 +189,10 @@ int ps2_command(struct ps2dev *ps2dev, u
 		return -1;
 	}
 
+	printk("ps2_command get mutex\n");
 	mutex_lock(&ps2dev->cmd_mutex);
 
+	printk("ps2_command pause rx\n");
 	serio_pause_rx(ps2dev->serio);
 	ps2dev->flags = command == PS2_CMD_GETID ? PS2_FLAG_WAITID : 0;
 	ps2dev->cmdcnt = receive;
@@ -198,6 +201,7 @@ int ps2_command(struct ps2dev *ps2dev, u
 			ps2dev->cmdbuf[(receive - 1) - i] = param[i];
 	serio_continue_rx(ps2dev->serio);
 
+	printk("ps2_command synaptics\n");
 	/*
 	 * Some devices (Synaptics) peform the reset before
 	 * ACKing the reset command, and so it can take a long
@@ -207,29 +211,51 @@ int ps2_command(struct ps2dev *ps2dev, u
 			 command == PS2_CMD_RESET_BAT ? 1000 : 200))
 		goto out;
 
+	printk("ps2_command sending bytes\n");
 	for (i = 0; i < send; i++)
 		if (ps2_sendbyte(ps2dev, param[i], 200))
 			goto out;
 
+
 	/*
 	 * The reset command takes a long time to execute.
 	 */
 	timeout = msecs_to_jiffies(command == PS2_CMD_RESET_BAT ? 4000 : 500);
 
+#if 0
+	printk("ps2: testing timeouts\n");
+	timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+	printk("ps2: testing timeouts\n");
+	timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+	printk("ps2: testing timeouts\n");
+	timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+	printk("ps2: testing timeouts\n");
+	timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+	printk("ps2: testing timeouts\n");
+	timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+	printk("ps2: timeouts ok?\n");
+#endif
+	printk("ps2_command waiting event: %d\n", timeout);
 	timeout = wait_event_timeout(ps2dev->wait,
 				     !(ps2dev->flags & PS2_FLAG_CMD1), timeout);
 
 	if (ps2dev->cmdcnt && timeout > 0) {
+		printk("wait_event returned: %d\n", timeout);
 
 		timeout = ps2_adjust_timeout(ps2dev, command, timeout);
+
+		printk("ps2_command adjust timeout: %d\n", timeout);
 		wait_event_timeout(ps2dev->wait,
 				   !(ps2dev->flags & PS2_FLAG_CMD), timeout);
 	}
 
+	printk("ps2_command receiving\n");
 	if (param)
 		for (i = 0; i < receive; i++)
 			param[i] = ps2dev->cmdbuf[(receive - 1) - i];
 
+	printk("ps2_command mostly done\n");
+
 	if (ps2dev->cmdcnt && (command != PS2_CMD_RESET_BAT || ps2dev->cmdcnt != 1))
 		goto out;
 
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 7f52938..cd320b1 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -912,12 +912,14 @@ #endif /* CONFIG_HOTPLUG */
 #ifdef CONFIG_PM
 static int serio_suspend(struct device *dev, pm_message_t state)
 {
+	printk("serio_suspend: starting\n");
 	if (dev->power.power_state.event != state.event) {
 		if (state.event == PM_EVENT_SUSPEND)
 			serio_cleanup(to_serio_port(dev));
 
 		dev->power.power_state = state;
 	}
+	printk("serio_suspend: done\n");
 
 	return 0;
 }

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--2fHTh5uZTiUOsy+g
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="hz.bug.gz"
Content-Transfer-Encoding: base64

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
S4SHJcLDEuFhifDwiPDwiPDwiPDwiPDwiPDwiPDwiPDwiPDwiPDwiPDwiPDwiPDwiPDwiPDw
iPDwiPCwQnioJiOIAMLDCuFhhfCwQnhYITysEB5WCA8rhIcVwsMK4WGF8LBCeFghPKwQHqpv
wUQA4aH6IksEEB6qr7JEAOGh+jJLBBAeqq+zRADhYY3wsEZ4WCM8rBEe1ggPa4SHJ4SHJ4SH
J4SHJ4SHJ4SHJ4SHJ4SHJ4SHJ4SHJ4SHJ4SHJ4SHJ4SHJ4SHJ4SHJ4QHB+HBQXhwEB4chAcH
4cFBeHAQHhyEBwfhwUF4cBAeHIQHB+HBQXhwEB4chAcX4cFFeHARHlyEBxfhwUV4cBEeXIQH
F+HBRXhwER5chAcX4cFFeHARHlyEBw/hwUN48BAePIQHD+HBQ3jwEB48hAcP4cFDePAQHjyE
Bw/hwUN4qOZvigDCg4/w4CM8+AgPPsKDj/DgIzz4CA8+woOP8OAjPPgIDz7Cg4/w4CM8+AgP
PsJDgPAQIDwECA8BwkOA8BAgPAQIDwHCQ4DwECA8BAgPAcJDgPBQ/feHIoDwEFTigRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/gRD/
gRD/gTT/YRZtQgDmvvzclFRYOMhLlPbeWPuQOwIU//xnuRtAs3EgEkqeQVx94h4uY2de+7wI
68vFzKHpLJDAMuIK0N9kIK7dKJiN4/C2r95/+6j9SfoBBR5x7b2k1bJb49touuirs4vfLj5t
/U3moXSc2+jWiUnpgEETxwskjI5p2LU8gd/LtSkn1LGLZqrXbH24VMO7aZQE1Ngj2enZ1i8q
ocUsCPMyN2qZyzqJl7NQ4qJSR8iZpSSeEiVIkeKfw9FXVdnD8ry2eQ4+jJQTBTGlcSCezaxW
+1K9Lfz387/ajR/Pv3PJN0Ed2HxzZTa4dcTJW9voiuuqH3G9Kr4SC9erh4sqPoT35T7tmS3O
vl1kb5o9qfp8GvK7RtaeE5dbk1s/cNPJRDw7Zg0u2nUTHH05Vl3buDztclOcdlvWB/7aasln
mx9wDtnH5am01WnWYF7WYMk2i982jip7jeb28cYd5CYvreBka2hxJ6pN/e5kt5l109+/2+oS
+A6/XBcm5BYKQu0bWx2pT7+dXSntrv64odSZdpotltRo2ISzapTKqz1T6uR5mmhP61G8uGVD
SYhKhx+I/0ppNuRN1Ykl33HkNXq5K5svXP7lq6Vfo7nb7f6A5kL6NZrbuVuq12luVzuxYrPX
JrNFFK0NCTGmsu/iJVc8Hc4YIvmAUaFjtlhUM8FEoHJmFIHKYopA5cwoApUdUgQqZ0YRqJwZ
RaBTk8++oDDlETmbE6peiu7J8w9cjWyaixjp95HjjyW22CtF7x7nB/yv5jlrAaO2o7uvruXX
keNnQWvOVxQ7iR70e88l74ii/unp1J3X5UEjmTTCgE4PKtQOjTvvzq/P7G/f1JHVMJvq+ESd
D/nhx+um8e1bnYdd+/n7n4JwsVxs1fy9/aLMseOLI9vM6alG41+yZ4ly4qAYUp6/lZAT+jwK
5/F/HO9+xvNOea5zls50Ju+e6IlRGlMMGfJsu5QJKWg0KqMSaHepduFedVMDbVSVOU5N9vtY
tWubwXX05ddT8ZKvPgckoYGK9UO95JvYblhG/d6qDRfROtaVkDh3Zq/Xy1wcZxPzcCGd3pEp
tfEjU5pV9goeSFn6Oyl9pR+OebB1g746kjCG5ytxqZv0rUbrg3ua9L9NfbpTK/NY6UiVfd/u
W62+2QOhNgO6M4os5fuzrA4babgIQ15tcFVrkcewtK2G1+cVkd1UZrMxSG/ZYkZHUeIuboPQ
f+vMojunMYmd8D4IG7wTkHxeZvCsEU6U3Wg1LLt+36x/Howu8rc2zQBaoTYajTY+op95h7Ya
zeqYn1EU6ffPgok0H+uda5PnCyYZfUrOnEXy3dUZkLr6dDHqlxxUdxtcr/Nru2GYPf7y7fr6
H+rIX4fOnAvs3Tls41lyIuENf+bp/rhRG2YaPJmDvQ0YzV63J85sg5ASQZeERPwaTnU+tJYn
Q179cN3CqdOoURr2i2Rnpq6/fj69How2UbJyw/MSKZM8Gm5t3FSXzkr9wkNWuHbC5H6tfuKy
3b99SJ2ZRPVu8MdfKxf1aVhzvXnTXq3ynPKFcOb12nOibCVZDBFsLF4KGTUuroy+6jKd0bQ+
ygdjdV6/ODsvFLEGzjdJ0rnkbNuXH59UHkbGTROVRAGvUqQso4tf9Som+Yta8Isxv5h5CeYv
LPnzalUbMf5Fi6jfjlecbugh6VCqKan5+PEm8d+okPNMVBr5jh4H6jyPBE4SKHGCzlmNdUS0
eeaQePti/IMvOne7AcWtfjlk2r7kwUceQ/gJr8Kl19mWSmYLEjfOmYths9FSH9woEXf6Sjzu
q6vB9SCLZrpH3SRzDt9uulPenHkPKporWWR6s4WKZOqYpXMVyUbnB6MsTDZhIBIvmRqqryT3
yll3kVBWZZZNaZGk3PChvwkKoxWZr1RkIkXWKxVZSJH9SkV2lSKHHLOftxT3069nl4NT07aV
4zqxmpuG1XwrkXOa/I8bXS/9898lKuw0flCmKUq4Rc++Xl7+Q77bpe/N0vcio5lE0U2jLWKO
rq7IIe5wpmmrq8Jjt20Yx/q1hgzg/GK901cfr69aTZM3YR96VwPDOFGX7+yLYdv4eFIqP/f+
zXum2bFM7ek84clnEcvYKCOC4hlPfXo3aHbVVrgUaEKMuNFWNTw58W1ADL2+oVtF6a/8n7dH
MedYH3jilFu7KpfK63/PaqF0LdTof3gSV4PPVwz3/cteySBXz7n527xuEt/5Xqpry7TqEk1D
3fFq6lFWXHnt1VGbu7DFGR7vUfAtnvI7PFbJsYBs/RaTyR6xS5lLroIw0bFrlO3Ip7GvRJlC
HYukXyz6Tnh64yXX84dFrMXcZ7k6G/2quMrvvw6qzM+5/D8yhGJdffkw5cOSj8q1mkiC9MoF
jdb/sjIDIkcfDOmIGjyW3O8IbZJ1fygWU8mtkUXz/MGzG4l7nw/o25Dc22jZUtp9b2xGuMqt
2bRr2e0WT3jZQvDiaiDqhypfzD6L9VKxe98oOuPBxF0s7tU166lbrO5yeDHYp/Azr8pGV6dW
EaJA4n3c8FPDNuz+L+/OTuT7xLT7l79+/Z7FrGkbJ/zRzMbdk0NRqrdlMppWLWHrL/pK/6JY
bTaIv1S3Kzj4+vdDgpWImR8KQZJp15/Vf5GYOOn+wAElDWZN8snNN1/ICifHgCwpeQ0j8hL9
4WBxis3MkhfAleXREpWdSEtUGkVLVB6F6B1msxYl1lhqIJHSA4H4zhOeZ3juomC18zRypPrx
7sOENwQRTb1kExtlqK6iwLmXGDX7drfVWz4p/27pEl5FiKgO2bSTIoF+JUW/JKHUWzV5NNa/
84jHq/Uw8LOE8nuO/7ucEMowsEjpZTpPpsFUet/O0zkvcGZrHjPD4P/Cev92lf9b8j96yVFv
bBVdZ3CtrmPeuspE5cu0pSx1H6zdhRxU7e1MlWeWusCtP5Th/q3+afzn7J1qq4GLN84vXnhj
fxqPJZLcWr3hh294lI91DPLywcpUin+i5wJeLT06URSIJi68IwsHX1mNdsNq1WPPUn+yut2a
uvnJM0y3Y/aaf/2udD6Fvj8bK795KrF8jY2Ybfgs5nHGFIy1tC4RizZ9FnVzyabRsXyTJbmg
mZjj+3nMHpa1TJZtbmTbbPBcNhMpF8EMWixsWbl0y+oGbSnD39T4UVaW4zSUQGciKSWwtiVw
rZ6UlVti7C+yQzqpUk+kvFzM8qyObWt1bDPedHOtwmg89aWU9qmEFc/zNV2zaxX6RKZQaFks
1trq62oxkcgrUwi2rJKFbNNyrQ4LZucxmdDWQt2OGL6zrfTEziudRNPwQJ1Zp99zWWw8zrU6
ej3Kcq5bqottmkFbbCNnIwy1ccBCkrc0o5ins1XY6/W2hdyoM3u72XqBkZXuRcbGTr5WR7e0
5KsBoYWleDttzEZsdzOFJTPGsgQNcpXNrcpJ19+WsAQcW0wz2Viw49hdrVIPLlsLdsXQm4wn
npuhYT5NdnpCIGAwm6US2p28mQupbXXMTsk8HXNiZL1GkCPB/ASFpVzbE7fVk7LxEiUMZoWI
aUnR7ELKbHY7Osu/KYodtods63hVmowX4Z8lbH25p7LKZiez4K5So6zydVKm0TK8zrZ4dCfD
zvgumEW6sp28Kj/v/1eTbi1V11e1nb50c+5rMa9hS5G9NkI8q+gRTz76PMQ58VxO9mQbxEMp
D6sh3Z2otX1fvQGQDCiYR9Xh/PSlE6+ofbm1mfqG4holi9CZyUFwqXTyio4Iy0N/IWxi4cq1
c4bq+lwP0bWd3ySEt0ezvmo2TLth1PVv6kjuCOqmUTe7x2qaX9InMl/587ovGb7l7O8cknPl
2vnZYKguh/revK/jUhrqfeAqsyc3+d2aF6VTf8aNkOp4cbdytiuX+jPul1yeQ8nzIExr4YSn
uTAUGN6XzudbEiXWbNvdJndw7z6g5CQPeDp3Vse1aTTOgppmp+RZ4Gq5ifgc0GQ6k1CKQ241
dR04cx3M1Etd3jyXZjcUA9bEEp3al9FwRyT1I+lQYaL3fNktROOFFHn7pKZBEHQNyzT7in80
TN578x74lBcAzm3ApqLT/GZarve8+xN1OyW5VpSLxdK7pYuyzDBNMUzr5RWN+ul3NqsEeX07
k4uAhmYbZPcIG31jL15HtNO7nNntgufKu7l68/nrp09vXiv87Xz0pnaRxTwXGPRG0mrF8Uzt
q8bGxeiCMV2/uuNHXkrZsXcV1yRKx/7cGeenH5Wsoux+60dEJdhfentXLKp4CUia5/TIG0Ae
Ribxgus1D+ZvVH4grMWu1qEnWhmHQXYLkqhGo6GXb9kByCgOeHUgMvktyUT3hrlKJPBk7X0c
BE+SystU3q9HcsURZUEJg0zVUTBzIu6u3FEMfSK7CP3kOM9h8zpPcrxQ00WRRzpgIznJ/St0
SCnPZTmtaSmbkhUBEovi80CqF91FPbRUFhhRXdm1YuBU2xG0vzGVPoHITiPMZ0/H+W/6JjuW
Zfbz53op7NC962canuvdo+EPs1MQbtberUKv163cKvzw3myf0bJzKf25tZn+dY/Nnj3PlJaO
KDc2f3G2KZ2Ae0841UjUB5z6gHafKC2iSKRenIDm6uV+5fDVyy4tRO3+ui3iDkVCPSdM5EJC
kNP0tb7Su9FywpgxPkkKY9SK1YEqQv1utWQhq1X2o/Q4jPSyxX35yHnWFFzTlU7oPU8QxEtC
d5vwfE2UP5ebnHU+VG0yar/Mu/XyUfN/27uy3rZxIPzuX6G+NUDjkJJ8BdgHJ3HQAr3gZLct
isKQJbrxJrEXttw2/345pA4eM0wTd4EFmqIFKn48RjM8ZkYztF+UGMLWa11HSXgVOVrR4s7S
/E32mEQ4iWC9SQptRIVTONEcNfZTHvAqOKSZaCqY5kqusRv1g/AQMgYnsvhRPrN+UZovuga3
kG+2JjSTLWuj5EHUVZ9oG+ocCjDmaQRlnkQEiRTdAYkkJIIJViMUbQVJQU6Ok5Pj5OQ4OTnO
nEJAISMRo00VnnuodKm2jjX51Ab0+u3Hy5eT6RtrDTkIJxG3t1cnb6Q+P/IBPWWO44Qodwev
y92h63Kif74gygVRXhDlOVE+J8ozonxElA+J8gFR3ifKe0R5SpQT/OcE/znBf07wnxH8ZwT/
GcF/RvCfEfxnBP8ZwX9G8J8R/GcE/xnBf0bwnxH8Nxdfqzisy2txp9dUf+isqfoHxROrfJ6V
cqO+i+BT4ykb2+ed+llzuXbfv/swmVqQyKsWyModX77hsXN0Gmudo0AyGCIt6o+hKHCCjaGp
SnFgSLVAyQWAU4NzqgWjqYrJXY7ZW/RsA0Hx0GjMbDHOVYBq1d+Ehs4oGmzuw1gqGEeD59Z0
9sF+COyFwDQEJiEwDoE8BFK8Nt9f26ZSQ6kWx8DuE4F9jsMC+TA9eeuPKJGLTxeX9rHXqN/z
7K6LlRfr/NoEwKJtbIcqg6mEAAOpaA7i2v7ttMkYq/XqUKVVnL7/U1nMnbPKBQ8Lelasv69w
A/f1+HLiaO2VuWUh99gteF3MeLFqImaJjdu2iYO5mnkI5mHYH9hV1C0Y09aJ9rWGbcGImh1q
ThLf6Mg0LMKw0pZDsEu6rzeH4CDlRZi0PDx2Hh47D4+dh8fGpqKrX4dgt3VI08ZXRLVT4GC9
XVhodPVdebQOWRLH0WfGvmjP0UyVzrSfC/4YzjLTBfb5IvnSOQHHdrmOTp/5o03G09efIB9w
dys8Qi0w9Lp2Lx7bQjAPwFpkNJzfBwc7V5MtBCchuAiPXYTHLsJjF/eNPQjBIkza4j7YpRzZ
2ULNXdKxjZVonwThZlsPwSTbmyPFga3TCF8O7Ulm4cEzEa+Jn7RWXeu8thD0rLdqaL/N5PQY
PviqzxnvTs51MPTmVn1zgahUiEkVP/5RAbFllK3uopv16qvYdJH2KihBfQd6QDfeLqPIU35i
Z4dpAF/PaiBMPWs7xFW7IM7dcQ2Nsm2I6aEBlAfROIgmQTQNor0g2g+iA5cRpm3h8t80SHBs
4vPIM4BwxnsSMQ0tH6ltMx/hASQhkJhsMySR2jT1kROyTYJSYNrMHtKY2TZiWuYN4pjyrRh8
678VH+I1MIayXQ0NEPJT4PKNKSChgJQCehTQpwBvlhuuIBwYUUBGAXMKyCmgoABBAQsC4BTb
ObXRcUoenJIHp+TBKXlwSh6ckgen5MEpeXBKHpySB6fkwSl5cEoenJJHTMkjpuQRU/KIPXmY
fnbv8Gx98xTkUWB9BWihgK7fVAJ/BmTDqG/OYGLopKsqXECeCtjdHVkJGThbUUY8ev4920Yj
gJMXStFQQRnwPDhArIh24EfeGOJbHvu8CyfehTnvkhwgNo15SDr2zONeE9oir6ltoEd3yfEu
4z04B80Nzg005yAQp896Bu/g6eDBBMc4wcl+BCcGwQtNcMpSU9LwOD/Yt++R7hvsJd72LdKY
w7+9ux/q7g2yxXzBRAbpmXt2bYjRXgJDNti/90T3PuRO3/KZ7987b7lu9q46Hzx8CibYFCzo
RV90OQ3FNJTQ0ICCxF4bODQn+Naz+MYezjeBb18Lmm+LvTZwlVrovUs8HNovowvk0kN8IO1p
6URRVMb4Y7Pdi3XVg452kv8X5ay9E6gDwbLms7TNZ5AeXo8L6XLra8Qr05oKiEfmMWeEdXmJ
78Xx5dZ4cCgIXQqN56aB7LietkUbAYRVjZGqCVKWImU9pMzUcL2w8BrwgqYcxIiz8gbIkLK5
xSHLeeV7WVrHVYN5AWY/48xCTD/UkdVy3YihQwvrwDsd5qcD704hh2G73m3kBCu3ebSDUF0I
GX1eiJsyi/6IDnma9nssTeNRL1ptDzqXcl4eR1f/yCWcG60hOGouxCpa6mhfUXT3v7cAgq/y
2yISiyPtmWj+ZhBEnOdCFNVFDHaDRe/IrK0b6BhxUUTrXYkPwqulFByEuujgpyocR5OXKlHo
RpRy39iVaz0ZZlu5zGcQgOwLUjhfFNtd0IqFbefirw96xQiVkyD7Jqq+8ApGSRW9i1aDmMW5
qL/AwPwjKpJ9/K8I/H3uVPh93vQpf/spC/qJ8ifKH0+5nfrSHNboF0bLxqotEzN+iXdH/bSJ
X4Ja59JG2cINslX0f7czFXVKh5EA9B/wr00emmpKVYoUXD+2VClnR5Lyo+Y2ndMrkV8DTVfL
udisdFba8jb7Kvv41Zusfe3Gr0jCN98QFOhokS2Vqhu61qXQOZ9jqTHoy6qh1nT86izKNpvs
bttV8EUO9w/K4yvSxBbq/5XUdRWlc+xWKi4NnkGgddnZu7eTbuf6b6mNr7Kboknn6UZwSeLt
sroI9Ft2E/WaiTP5eJkcLrZwv+tOJfe36Wv6ir71plAas/oaDXl53c5f5xfH8vjV9dXHxufi
R5kYTQ/U6bpe3dzpvDR43d1qB2lnOgO4uj75OJKKwLXKUwveKfstD/9OrsTl5IJ3ic4vwPEA
Vy+90O8reRFVPOn8CztZBmbmBgEA

--2fHTh5uZTiUOsy+g--
