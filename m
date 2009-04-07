Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZDGJOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZDGJOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZDGJMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:12:37 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59663 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbZDGJMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=U82/YII8kNHYv8SbB64EkRd6BDJMwNcezZZCJg5mik9mR/vEl79cblg5IXZiEmtoN1
         Dp4anwKxsOFvYMBXjaWOFB1Hs9V5TME71cN+XHNyTYxmKxMN/EsCqCJOwVF8hdFwfrWL
         KbGOB0fIwNKhKTIgaWqYpluoBshSPbM0I6t+k=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.29 git master and PAT problems
Date: Tue, 7 Apr 2009 11:12:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200904020912.23071.a.miskiewicz@gmail.com> <1239058353.4529.7124.camel@localhost.localdomain>
In-Reply-To: <1239058353.4529.7124.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904071112.28949.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 of April 2009, Pallipadi, Venkatesh wrote:
> On Thu, 2009-04-02 at 00:12 -0700, Arkadiusz Miskiewicz wrote:
> > On Thursday 02 of April 2009, Pallipadi, Venkatesh wrote:
> > > On Mon, Mar 30, 2009 at 05:28:15PM -0700, Pallipadi, Venkatesh wrote:
> > > > On Mon, Mar 30, 2009 at 03:31:09PM -0700, Arkadiusz Miskiewicz wrote:
> > > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > > > >
> > > > > More info follows. Now I've switched to
> > > > > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm
> > > > > fixes and now I get much lower numbers of PAT errors but still.
> > > > >
> > > > > > On Mon, 2009-03-30 at 14:31 -0700, Arkadiusz Miskiewicz wrote:
> > > > > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > > > > > > > Patch here should get rid of these errors.
> > > > > > > >
> > > > > > > > http://marc.info/?l=linux-kernel&m=123788806506230&w=2
> > > > > > > >
> > > > > > > > The patch is in tip and on its way to upstream.
> > > > > > >
> > > > > > > The problem is that kernel I'm running already contains this
> > > > > > > patch (it's merged already). Other ideas?
> > > > > > >
> > > > > > > ratelimiting that error is good IMO anyway.
> > > > > >
> > > > > > Rate limiting will just work around the problem here. Ideally we
> > > > > > should never see these errors. So, it will be better if we can
> > > > > > narrow down on the bug resulting in these error messages.
> > > > >
> > > > > Of course it's better. I'm saying that when these messages "fire"
> > > > > then it's hard to do anything else on the system for a while until
> > > > > these stop.
> > > > >
> > > > > > Can you please send me the output of
> > > > > > # cat /debug/x86/pat_memtype_list
> > > > > > with debugfs mounted.
> > > > > > and
> > > > > > # cat /proc/mtrr
> > > >
> > > > There seems to be two different problems here.
> > > > - We should not have that many single page ranges reserved. That will
> > > > cause a performance problem with drm even without the "freeing
> > > > invalid type" error. - "freeing invalid type" error itself. Seems to
> > > > be caused due to some unbalanced free along the drm path. We tried to
> > > > find anything obvious in the code that may be causing problem here.
> > > > But, haven't found anything so far. Will try to reproduce the problem
> > > > internally and debug it further.
> > >
> > > OK. I think we have root caused the thinko that was resulting in
> > > "freeing invalid type" error. Can you try the below test
> > > patch. Patch is not final version and may need some cleanup.
> >
> > Was testing on linus git as of today +
> > [PATCH] x86, PAT: Remove duplicate memtype reserve in pci mmap
> > + patch from this thread.
> >
> > It doesn't fix the problem. At least I'm able to reproduce "Freeint
> > invalid memtype" by just running http://www.tremulous.net/ game. It also
> > happened when watching youtube with opera. _Maybe_ things are little
> > better because number of "freeing invalid memtype" messages is much lower
> > than before but there is posibility that I simply didn't trigger it
> > fully.
>
> Arkadiusz,
>
> I was finally able to reproduce the problem of "freeing invalid memtype"
> with upstream git kernel (commit 0221c81b1b) + latest xf86 intel driver.
> But, with upstream + the patch I had sent you earlier in this thread
> (http://marc.info/?l=linux-kernel&m=123863345520617&w=2) I don't see
> those freeing invalid memtype errors anymore.
>
> Can you please double check with current git and that patch and let me
> know if you are still seeing the problem.

Latest linus tree + that patch (it's really applied here), xserver 1.6, libdrm 
from git master, intel driver from git master, previously mesa 7.4 (and 7.5 
snap currently), tremolous.net 1.1.0 game (tremolous-smp binary), GM45 gpu.

To reproduce I just need to run tremolous-smp and connect to some map. When 
map finishes loading I instantly get:

      1 [  132.341378] tremulous-smp:5554 freeing invalid memtype d570d000-
d570e000
      1 [  132.341394] tremulous-smp:5554 freeing invalid memtype d570e000-
d570f000
      1 [  132.341409] tremulous-smp:5554 freeing invalid memtype d570f000-
d5710000
      1 [  139.323677] X:5238 freeing invalid memtype d6168000-d6169000            
      1 [  139.323698] X:5238 freeing invalid memtype d6169000-d616a000            
      1 [  139.323722] X:5238 freeing invalid memtype d616a000-d616b000            
      1 [  139.323742] X:5238 freeing invalid memtype d616b000-d616c000       

$ dmesg|grep "freeing invalid" | wc -l
6643

> Thanks,
> Venki

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

