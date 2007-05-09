Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbXEIOMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbXEIOMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXEIOMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:12:03 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:40543 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXEIOMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cW5T1Ejdoq4iDijgt1taYynEK6ekQm3g9hFcLLbtyvfJq+bI6s7T5z+AdHoc6RG12KPt5r0L78tkFFpjkxlqPWNRqeGmKXgmcUTVmkfg0caJol+hit+7T1V5CRe//7k3baaKROZmheyimcYfoc1IgA5dLsApLo/6mSxT1ZOF38g=
Message-ID: <4641D6A2.8070406@gmail.com>
Date: Wed, 09 May 2007 16:11:46 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       maneesh@in.ibm.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "cornelia.huck@de.ibm.com >> Cornelia Huck" 
	<cornelia.huck@de.ibm.com>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x (kernel
 bug 8198)
References: <691707.19263.qm@web52910.mail.re2.yahoo.com>
In-Reply-To: <691707.19263.qm@web52910.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Rankin wrote:
> --- Tejun Heo <htejun@gmail.com> wrote:
>> Okay, here's a half-assed fix.  With this patch applied, if you try to
>> unload a module while you're opening it's dev attribute, kernel will
>> oops later when the file is accessed or closed later but it should fix
>> the bug winecfg triggers.  I really dunno how to fix this the right way
>> in the stable kernel.  Better ideas?  Anyone?
> 
> How about a WARN() and a small(?) memory leak? Better than an oops, surely?

Device node creation/deletion can be quite often depending on
configuration, so I don't think we can afford memory leak here.  It can
develop into a big problem for long running hosts.  IMHO, just
introducing module unload/deletion race is much better.  It's the lesser
evil, difficult to trigger and already broken in other places anyway.

I think we need to hear what other people are thinking about it.  Cc'ing
Maneesh, Dmitry and Cornelia.  The whole thread can be read at...

  http://thread.gmane.org/gmane.linux.usb.devel/53559
  http://thread.gmane.org/gmane.linux.usb.devel/53846

The thread is rather long but just reading the message from the second
URL should be enough.  The problem is that dev->devt_attr (class dev has
the same problem) is deallocated when the device is deleted.  If the dev
sysfs attribute has users at that point, the dev sysfs node is left with
garbled struct attribute causing oops later.

IMHO, the proper fix for this is immediate-disconnect which is no in -mm
as the problem is caused by expecting immediate-disconnect behavior when
it isn't implemented.

As written above, I think it's better to risk module unload / sysfs race
than keeping the current sysfs deletion / open race.  What do you guys
think?

Thanks.

-- 
tejun
