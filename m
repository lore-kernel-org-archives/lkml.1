Return-Path: <linux-kernel-owner+w=401wt.eu-S1762702AbXHGLrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762702AbXHGLrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbXHGLq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:46:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:9530 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448AbXHGLq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:46:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=m6OI3AOEUaGiexxxzwqr1GYkQTGyxPBu4PiLsRnW19oDghMMLmvUDzyqIdIGYFhn0sFuuZ5xf6dHFEU45ytnfwLHUz+zWoWpk7GjqtIF1ATFeYqM7IFL7L1KlcL93dzUwzUvWcwsjX8MG4LYq9gU9KpWU9hb10/LXb+kXWqh4JY=
Message-ID: <3ae72650708070446y6452d13jb7cd802119dab3ce@mail.gmail.com>
Date: Tue, 7 Aug 2007 13:46:55 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not notified
Cc: "Javier Pello" <javier.pello@urjc.es>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20070807125844.4d756b04@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B37CF7.2020803@urjc.es>
	 <20070806142451.5d28d41c@gondolin.boeblingen.de.ibm.com>
	 <46B7832B.6010808@urjc.es>
	 <20070807125844.4d756b04@gondolin.boeblingen.de.ibm.com>
X-Google-Sender-Auth: cd180399d3c3b4a4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Mon, 06 Aug 2007 22:23:07 +0200,
> Javier Pello <javier.pello@urjc.es> wrote:
>
> > > > 2. The second part changes _request_firmware in
> > > > drivers/base/firmware_class.c to actually check the return value
> > > > of kobject_uevent and skip the loading_timeout delay if the
> > > > loading event was not delivered to userspace at all.
> > >
> > > Note that kobject_uevent() returns 0 if the event has been filtered.
> >
> > Oops, yes, I had not noticed. This brings another point: When should
> > kobject_uevent return a "failure"? The code, as it is, only returns a
> > failure when things are really wrong (out of memory, etc.), and
> > returns success when the event was simply dropped. This is reasonable
> > behaviour, but it prevents callers from knowing whether the event was
> > actually delivered (which is what request_firmware needs). On the
> > other hand, my patch tries to make nondelivery an error, but on
> > second thoughts that could prevent the caller from telling hard
> > errors from simple nondelivery.
>
> You could say that not delivering is caused by a hard error when trying
> to deliver, though. OTOH, filtering an event is certainly not an error.
>
> > I can think of two possibilities
> > to sort this out:
> >
> > - kobject_uevent returns an error code both on a hard error and
> > on nondelivery; the error codes for both situations are different,
> > so the caller can tell them apart.
>
> Tough. For example, both today's kobject_uevent() and
> call_usermodehelper() may return -ENOMEM.
>
> >
> > - kobject_uevent returns an error code (<0) only on a hard error,
> > returns 0 on nondelivery and 1 on delivery; this makes things
> > even clearer.
>
> Hm, I have an aversion against tri-state return values :( OTOH, a)
> callers generally don't care and b) it is in line with how
> kobject_uevent() is defined if !CONFIG_HOTPLUG.
>
> - Use an extra parameter in which successful delivery can be indicated.
> Make this
> int kobject_uevent_env_check(struct kobject *kobject,
>                              enum kobject_action action,
>                              char *envp[], int delivered);
> so existing callers that don't care don't have to be changed.

How do you check if events have been "handled"? None of the recent
distros uses /sbin/hotplug anymore. Netlink events are broadcasted,
but no failure in delivery doesn't mean anything like "handled", or
delivered to the right instance. Even if you check that the netlink
socket has listeners, that wouldn't be sufficient to tell that is is
handled.

Thanks,
Kay
