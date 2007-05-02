Return-Path: <linux-kernel-owner+w=401wt.eu-S2992909AbXEBIls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992909AbXEBIls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992911AbXEBIls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:41:48 -0400
Received: from netblock-66-245-252-131.dslextreme.com ([66.245.252.131]:34715
	"EHLO Angel.zoy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992909AbXEBIlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:41:47 -0400
Date: Wed, 2 May 2007 01:41:46 -0700
From: Michel Lespinasse <walken@zoy.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
Message-ID: <20070502084146.GA6089@zoy.org>
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637BA70.8000108@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 03:08:48PM -0700, Kok, Auke wrote:
> Michel Lespinasse wrote:
> >(I've added the E1000 maintainers to the thread as I found the issue
> >seems to go away after I compile out that driver. For reference, I was
> >trying to figure out why I lose exactly 24 ticks about every two
> >seconds, as shown with report_lost_ticks. This is with a DQ965GF
> >motherboard with onboard E1000).
> 
> that's perfectly likely. The main issue is that we read the hardware stats 
> every two seconds and that can consume quite some time. It's strange that 
> you are losing that many ticks IMHO, but losing one or two might very well 
> be.

Ah, interesting.

So, I dived a bit deeper and added printk's all over the place to
trace what's going on. Here is what I'm seeing.

For some reason (I suppose something wrong in the hardware init code ???)
e1000_get_software_flag() does not succeed. It just loops PHY_CFG_TIMEOUT=100
times, sleeping 1ms each with mdelay(1), and then returns (after 100ms)
with an exit code of -E1000_ERR_CONFIG.

Because of that, e1000_read_phy_reg() does not succeed:
it calls e1000_swfw_sync_acquire -> e1000_get_software_flag and then
returns -E1000_ERR_SWFW_SYNC

On my system, every e1000_watchdog() invocation calls e1000_read_phy_reg()
twice: first near the top of e1000_check_for_link() within the
e1000_media_type_copper && hw->get_link_status condition, then within
e1000_update_stats() to read and update the idle_errors statistic.
Each call results in a 100ms delay. The second call is enclosed within
an spin_lock_irqsave()..spin_unlock_irqrestore() section, so it results
in 100ms of lost ticks too.

Now I have no idea how to fix that, but it does seem like it must be an
initialisation issue. Possibly it might be a matter of telling the firmware
"management engine" to keep its paws off of the adapter, I dont know.
If you want me to add logging within the init functions, let me know.

The other operations - like all the E1000_READ_REG() calls within
e1000_update_stats() - seem to take negligible time compared to the
two failing e1000_read_phy_reg() calls.

> I've had good results with 2.6.21.1 (even running tickless :)) on these 
> NICs. Have you tried that yet?

Not yet. Coming up... I'd prefer not to rely on new kernels at this
point though - but I can certainly try it just to report on current status.

-- 
Michel "Walken" Lespinasse
"Bill Gates is a monocle and a Persian cat away from being the villain
in a James Bond movie." -- Dennis Miller
