Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZBKHMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZBKHMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZBKHMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:12:13 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:25152 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751600AbZBKHMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:12:12 -0500
Message-ID: <49927A02.9020006@shipmail.org>
Date: Wed, 11 Feb 2009 08:10:58 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Dave Airlie <airlied@linux.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12574] possible circular locking dependency detected
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>	<sWhNs83kKPE.A.4cG.E30jJB@chimera> <20090210223711.GA6809@google.com> <1234305716.32506.10.camel@gaiman>
In-Reply-To: <1234305716.32506.10.camel@gaiman>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Anholt wrote:
> On Wed, 2009-02-11 at 00:37 +0200, Michael S. Tsirkin wrote:
>   
>> Dave, dri guys,
>> Could you take a look at this circular dependency please (below)?  I
>> observe it when suspending laptop with radeon drm loaded and with
>> lockdep enabled. It seems that the root of the problem is that
>> various vm ops such as drm_vm_open, drm_mmap) are called with mm
>> semaphore taken, and take dev->struct_mutex. On the other hand,
>> drm_rmmap_locked is called with dev->struct_mutex, and calls mtrr_del
>> which depends on mm semaphore indirectly.
>>
>> What do you think?
>>     
>
> Yes, there are real lock inversions now due to the GTT mmap code.  It's
> going to be a pain to fix (I tried getting the mmap_sem -> struct_mutex
> path to go away, but the fact that mmap_sem is held over the fault
> handler pretty much kills that).  It's high on the list, though.
>   
Shouldn't it be possible to relax this given that in the fault() 
handler, the mmap_sem() is taken in read mode only. This means that it 
should be deadlock-safe (but still a little ugly) to take the mmap_sem() 
in read mode when the struct mutex is held.

Another quick way to fix potential deadlocks, would be to take the 
struct mutex in the following way in fault():

if (!mutex_trylock(&dev->struct_mutex)) {
      needs_resched();
      return VM_FAULT_NOPAGE;
}

/Thomas

>   
> ------------------------------------------------------------------------
>
> ------------------------------------------------------------------------------
> Create and Deploy Rich Internet Apps outside the browser with Adobe(R)AIR(TM)
> software. With Adobe AIR, Ajax developers can use existing skills and code to
> build responsive, highly engaging applications that combine the power of local
> resources and data with the reach of the web. Download the Adobe AIR SDK and
> Ajax docs to start building applications today-http://p.sf.net/sfu/adobe-com
> ------------------------------------------------------------------------
>
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   



