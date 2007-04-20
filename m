Return-Path: <linux-kernel-owner+w=401wt.eu-S1030929AbXDTQfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030929AbXDTQfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031025AbXDTQfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:35:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:16462 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030929AbXDTQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fh5STb+6OcDJ+sYFSdlp65lJeVLU+pvwwky/84AXDReniokCOvKi4k4aUpT/+kHcRMBAILs8Sxem2unWxiGSqjw8LPPGcwQQN1jwMu0WQjpJ+XkF3gp/x31FZ44ikqOzKaj7N1xjdmfNSI3oJFJGfg7ho6+DgbmGensaD1mn3NE=
Message-ID: <d120d5000704200935s6aacf367ncc229f5bb95b1e12@mail.gmail.com>
Date: Fri, 20 Apr 2007 12:35:19 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Cc: "Tejun Heo" <htejun@gmail.com>, "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <Pine.LNX.4.44L0.0704191744380.6354-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d120d5000704191139m3caf4cfeqd95047d1c33faf64@mail.gmail.com>
	 <Pine.LNX.4.44L0.0704191744380.6354-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Among the worst offenders are character devices.  None of the subsystem
> providers offering char device registration performs immediate detach --
> they are a lot like sysfs used to be.  (In fact, they probably _can't_
> provide it since read() or write() calls can block indefinitely in the
> lower-level driver; the subsystem may have no way to force them to
> fail-fast.)


That shoudl be doable - the read/write routines should check if device
is still alive and return immideately when device is dead. When
disconnecting device just wake up all readers and writers and they
should eventually fall off.

Hmm, I guess am starting to think that using refcounting everywhere is
not a good idea. We are trying to have "immediate disconnect" behavior
and refcounting is an antithesis of it. Refcounting works well when it
is contained - register grabs reference; unregister puts it back; but
there is no passing references down between the layers. When device is
being removed it needs to signal downstream that it is gone and should
not be accessed anymore. And we need to do that anyway because if
device is really gone but its users ignore it they will get endless
stream of errors when trying to access it.

-- 
Dmitry
