Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYIDU6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYIDU6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYIDU6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:58:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYIDU6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:58:06 -0400
Date: Thu, 4 Sep 2008 16:57:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arozansk@redhat.com" <arozansk@redhat.com>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904205725.GC4349@redhat.com>
References: <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 08:01:31PM +0000, Mingarelli, Thomas wrote:
> Exactly.
> 
> The hpwdt driver is meant to be a catch-all for any NMI coming through on ProLiant HW only. Moreover, for newer ProLiant HW at that.
> 
> Once the NMI comes in, we call into our BIOS for the true reason of the NMI. That message gets logged to the IML in NVRAM for the user to view. We then panic the system.
> 
> Yes, kdump will work under this scenario because we stop the watchdog timer. This is a user configurable setting.
> 
> 

Sorry I did not get it. Few questions.

- So you want to capture every NMI and then do something. So what's the
  harm in registering on die chain and look for both DIE_NMI_IPI and
  DIE_NMI events and take appropriate action? Depending on reason code,
  one or other will be called. If I read the code correctly, you will get
  to see every NMI on that cpu irrespective of the reason and then you can
  take the action accordingly.

- How would kdump continue to work above driver hijacks the nmi callback.
  You will disable watchdog, log message and call panic(). panic() will
  lead to kdump and kdump will send NMI IPI to reset of the cpus in the
  system to save their state and halt these. The moment other cpus get
  NMI IPI, above driver will hijack that NMI also and nobody gets a chance
  to run? So kdump will not work?

  Am I missing something?

Thanks
Vivek
  

 
> Tom
> 
> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Thursday, September 04, 2008 3:01 PM
> To: Vivek Goyal
> Cc: Don Zickus; Andi Kleen; Ingo Molnar; Prarit Bhargava; Peter Zijlstra; linux-kernel@vger.kernel.org; arozansk@redhat.com; Mingarelli, Thomas; ak@linux.intel.com; Alan Cox; H. Peter Anvin; Thomas Gleixner; Maciej W. Rozycki
> Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
> 
> > Add "kdump" to the list. It will also be broken if we decide to let one
> > driver hijack the NMI handler.
> 
> kdump is a special case, similar to the NMI button panic mode. It should
> be always only active when the user configured it. When the user configured
> it should be always the fallback and override any other drivers.
> 
> But watchdog is a special case. I assume the watchdog will just log
> (and do the work that a SMI should be doing) but then continue
> the chain so that kdump can dump on a watchdog timeout.
> 
> -Andi
