Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbXEIOfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbXEIOfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXEIOfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:35:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:28477 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXEIOfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L058DAMBDKsPWuVGQWrJsj4Dln3v9w27v9BnL/bld3k39SXI4DzzV7bOKlWICPF+7H7Qvlh+J2dZMW+5TA7N2dwZGMGmO6RyODteB04sgaOXAWtKtkTReqk0OAyyB9HGBg2wZm/gu1jl0bEwFMRJW+FKVxzfXoM/l2w+bd48clA=
Message-ID: <d120d5000705090735o65591855yea6649d725fabb13@mail.gmail.com>
Date: Wed, 9 May 2007 10:35:04 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x (kernel bug 8198)
Cc: "Chris Rankin" <rankincj@yahoo.com>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, maneesh@in.ibm.com,
       "cornelia.huck@de.ibm.com >> Cornelia Huck" 
	<cornelia.huck@de.ibm.com>
In-Reply-To: <4641D6A2.8070406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <691707.19263.qm@web52910.mail.re2.yahoo.com>
	 <4641D6A2.8070406@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 5/9/07, Tejun Heo <htejun@gmail.com> wrote:
> Chris Rankin wrote:
> > --- Tejun Heo <htejun@gmail.com> wrote:
> >> Okay, here's a half-assed fix.  With this patch applied, if you try to
> >> unload a module while you're opening it's dev attribute, kernel will
> >> oops later when the file is accessed or closed later but it should fix
> >> the bug winecfg triggers.  I really dunno how to fix this the right way
> >> in the stable kernel.  Better ideas?  Anyone?
> >
> > How about a WARN() and a small(?) memory leak? Better than an oops, surely?
>
> Device node creation/deletion can be quite often depending on
> configuration, so I don't think we can afford memory leak here.  It can
> develop into a big problem for long running hosts.  IMHO, just
> introducing module unload/deletion race is much better.  It's the lesser
> evil, difficult to trigger and already broken in other places anyway.
>
> I think we need to hear what other people are thinking about it.  Cc'ing
> Maneesh, Dmitry and Cornelia.  The whole thread can be read at...
>
>  http://thread.gmane.org/gmane.linux.usb.devel/53559
>  http://thread.gmane.org/gmane.linux.usb.devel/53846
>
> The thread is rather long but just reading the message from the second
> URL should be enough.  The problem is that dev->devt_attr (class dev has
> the same problem) is deallocated when the device is deleted.  If the dev
> sysfs attribute has users at that point, the dev sysfs node is left with
> garbled struct attribute causing oops later.
>
> IMHO, the proper fix for this is immediate-disconnect which is no in -mm
> as the problem is caused by expecting immediate-disconnect behavior when
> it isn't implemented.
>
> As written above, I think it's better to risk module unload / sysfs race
> than keeping the current sysfs deletion / open race.  What do you guys
> think?
>

How about embedding struct attribute fro devt into struct
[class_]device for now? It is not too big and device is still going to
be pinned into memory while there are sysfs users... I don't like
fattening of device structures but leaks and/or oopses are worse in my
book.

-- 
Dmitry
