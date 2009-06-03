Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbZFCMSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbZFCMSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZFCMSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:18:30 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:60476 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbZFCMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:18:29 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [regression, bisected] adb trackpad disappears after suspend to ram
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	<200906011836.15507.rjw@sisk.pl>
	<877hzv8txp.fsf@scholz.fias.uni-frankfurt.de>
	<200906031202.28916.rjw@sisk.pl>
Date: Wed, 03 Jun 2009 14:18:13 +0200
In-Reply-To: <200906031202.28916.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 3 Jun 2009 12:02:27 +0200")
Message-ID: <877hzty0hm.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday 02 June 2009, Jan Scholz wrote:                                 
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:                                
>>                                                                          
>> > On Monday 01 June 2009, Jan Scholz wrote:                              
>> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:                             
>> >>                                                                       
>> >> > On Friday 29 May 2009, Jan Scholz wrote:                            
>> >> >> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:          
>> >> >>                                                                    
>> >> >> >> We are too late in the cycle to revert this commit and it       
> really is needed to                                                        
>> >> >> >> fix a more serious issue. Nevertheless knowing that it caused   
> the problem to                                                             
>> >> >> >> appear on your system is also important.                        
>> >> >> >>                                                                 
>> >> >> >> Ben, do you have an idea what may be going on here? Does        
> __disable_irq() mask                                                       
>> >> >> >> the interrupt on this platform?                                 
>> >> >> >                                                                  
>> >> >> > I suppose so :-) I'll have to check what's going on, it's not    
>> >> >> > immediately clear to me.                                         
>> >> >> >                                                                  
>> >> >> > Cheers,                                                          
>> >> >> > Ben.                                                             
>> >> >> >                                                                  
>> >> >> >>                                                                 
>> >> >> >> I'd like to see a boot log, preferably containing a             
> suspend-resume in which                                                    
>> >> >> >> the problem was reproduced.                                     
>> >> >>                                                                    
>> >> >> Here is a log from booting, through several suspend cycles, until  
> the                                                                        
>> >> >> trackpad disappeared. The first few suspends were done while X was 
>> >> >> running but from the console. As you can tell from lines like      
>> >> >> May 28 23:51:26 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f 
>> >> >> the trackpad was still present. The last suspend was done from     
> within X,                                                                  
>> >> >> here the trackpad did not make it.                                 
>> >> >> May 28 23:58:09 [kernel] adb devices: [2]: 2 c4 [7]: 7 1f          
>> >> >> However, there have been cases, although not in this log, were the 
>> >> >> trackpad has been alive even when suspending from within X.        
>> >> >                                                                     
>> >> > This means the problem is probably timing-related.                  
>> >> >                                                                     
>> >> > Can you please try to comment out suspend_device_irqs() and         
>> >> > resume_device_irqs() in drivers/base/power/main.c and see if that   
> changes                                                                    
>> >> > anything? It's not entirely safe (well, that's why the calls are    
> there after                                                                
>> >> > all), but hopefully the box won't hang during this test.            
>> >> >                                                                     
>> >>                                                                       
>> >> Tried that against v2.6.30-rc7 and it seems to fix the issue. I did   
> ~10                                                                        
>> >> suspend-resume cycles from the console (which worked just like        
> before)                                                                    
>> >> and ~20 cycles from within X and the trackpad is still alive.         
>> >                                                                        
>> > So, it seems we lose and interrupt during resume and that confuses the 
>> > ADB controller driver or something like this. Do you use the keyboard  
> or                                                                         
>> > the trackpad as a wake-up device?                                      
>>                                                                          
>> I do the wakeup by pressing keys on the keyboard. I'd try wakeup via the 
>> trackpad's button, but I have no idea how to activate that.              
>>                                                                          
>> > Please additionally try to go back to the original code, put           
>> > 'sleepy_trackpad = 1' at the beginning of do_adb_reset_bus() in        
>> > drivers/macintosh/adb.c and see if the problem is reproducible with    
> that.                                                                      
>>                                                                          
>> Tried this, but it does not help.                                        
>>                                                                          
>> What I haven't noticed before is, that even if the trackpad already      
>> disappeared, an additional suspend-resume cycle from the console brought 
>> it back to life every time. Sometimes this worked from within X as well, 
>> just not with such a high probability as from the console.               
>> However, this is independent from 'sleepy_trackpad = 1'.                 
>
> OK, the patch is below, but I haven't had the opportunity to test it yet.  
>
> Can you please check if it helps, on top of 2.6.30-rc8?                    
>
> Best,                                                                      
> Rafael                                                                     
>
> ---                                                                        
> kernel/irq/manage.c | 12 ++++++++----                                      
> 1 file changed, 8 insertions(+), 4 deletions(-)                            
>
> Index: linux-2.6/kernel/irq/manage.c                                       
> ===================================================================        
> --- linux-2.6.orig/kernel/irq/manage.c                                     
> +++ linux-2.6/kernel/irq/manage.c                                          
> @@ -187,9 +187,9 @@ static inline int setup_affinity(unsigne               
> void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)  
> {                                                                          
> if (suspend) {                                                             
> - if (!desc->action || (desc->action->flags & IRQF_TIMER))                 
> - return;                                                                  
> - desc->status |= IRQ_SUSPENDED;                                           
> + if (desc->action && !(desc->action->flags & IRQF_TIMER))                 
> + desc->status |= IRQ_SUSPENDED | IRQ_DISABLED;                            
> + return;                                                                  
> }                                                                          
>
> if (!desc->depth++) {                                                      
> @@ -250,8 +250,12 @@ EXPORT_SYMBOL(disable_irq);                           
>
> void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)    
> {                                                                          
> - if (resume)                                                              
> + if (resume) {                                                            
> desc->status &= ~IRQ_SUSPENDED;                                            
> + if (!desc->depth)                                                        
> + desc->status &= ~IRQ_DISABLED;                                           
> + return;                                                                  
> + }                                                                        
>
> switch (desc->depth) {                                                     
> case 0:                                                                    

Hi Rafael,

I tried your patch, but it makes my box crash on wakeup. It even reset
the hwclock which normally only happens with completely empty battery
and without AC.

Here are the last few lines of the syslog, and the first after booting
again:

Jun  3 13:53:12 [kernel] [drm] writeback test succeeded in 1 usecs
Jun  3 13:53:40 [kernel] radeonfb 0000:00:10.0: Invalid ROM contents
                - Last output repeated twice -
Jun  3 13:53:41 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
Jun  3 13:53:41 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
Jun  3 13:53:41 [kernel] [drm] Setting GART location based on new memory map
Jun  3 13:53:41 [kernel] [drm] Loading R200 Microcode
Jun  3 13:53:41 [kernel] [drm] writeback test succeeded in 1 usecs
Jun  3 13:53:47 [pbbuttonsd] INFO: Script '/etc/power/pmcs-pbbuttonsd suspend ac ram' launched and exited normally_
Jan  1 01:01:52 [kernel] via-pmu: Server Mode is disabled


Cheers,
   Jan
