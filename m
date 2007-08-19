Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXHSQFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXHSQFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 12:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXHSQFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 12:05:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbXHSQFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 12:05:34 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: group ownership of tun devices -- nonfunctional?
To: Mike Mohr <akihana@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sun, 19 Aug 2007 18:05:26 +0200
References: <8Tpwf-3Nb-1@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IMnHK-00012c-VC@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/UT8Eapi+CiGp+gUcuvwN0aFpoAglposO7xJO
 tDVpsVShcv5pFEoKmrfBL/viZrcwItpZCwNSBnKOESZ1ZcajVt
 ga0FQ3sKwjgziVKbLKwuQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Mohr <akihana@gmail.com> wrote:

(intentionally not snipping much)

> Per the post here:
> 
> http://lkml.org/lkml/2007/6/18/228
> 
> it appears that the group ownership patch has made it into .23.  I am
> using these patches, amongst which the kernel component appears to be
> identical:
> 
> http://sigxcpu.org/unsorted-patches/0001-allow-tun-ownership-by-group.patch
> http://sigxcpu.org/unsorted-patches/tunctl_gid.diff
> 
> I can create devices that are owned by my user account (tunctl -u
> `whoami` -t tap0) and it works fine.  However, if I use group
> permissions with -g it stops working.  In all cases, if I pass -g
> <group>, the interface is created correctly but it is unusable as a
> non-root user.
> 
> So my question is: am I doing something wrong?  If I am, I don't see
> it.  Assuming then that I am not doing anything wrong on my end, I
> assume then that there is something missing from the kernel patch I
> applied.  I read over it and I can't see any issues, especially
> considering that tunctl comes back without error (even with -g) and
> creates an interface.
> 
> Just wondering if this was an issue that should be looked into--


IMHO the check is broken:

+               if (((tun->owner != -1 &&
+                     current->euid != tun->owner) ||
+                    (tun->group != -1 &&
+                     current->egid != tun->group)) &&
+                    !capable(CAP_NET_ADMIN))
                        return -EPERM;

It should be something like:

+               if (!((tun->owner == tun->owner) ||
+                     (tun->group == tun->group) ||
+                     capable(CAP_NET_ADMIN)))
                        return -EPERM;

Please verify and forward to the maintainers if my guess appears to be correct.
-- 
Never stand when you can sit, never sit when you can lie down, never stay
awake when you can sleep.

Friﬂ, Spammer: xxh@n.btxp.7eggert.dyndns.org
