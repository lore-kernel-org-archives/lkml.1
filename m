Return-Path: <linux-kernel-owner+w=401wt.eu-S1765038AbYFHMki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765038AbYFHMki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYFHMkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:40:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:49094 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbYFHMka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=G/aekKnfkZPAWGCeqTR+kR0M2JBCKc3o4t3twyWET3C6MHC7xIbOxzEANgnk1sEmrX
         fNUAgWz6TCCI/k9QU0cZ2/S8Q51ElBFf0AO6mF+AZ+IdPOPxQig+OOyEhI+5sLQoc46n
         jSPbt7hCiW+xmgQcN36O44t892+UshroUfLbQ=
Message-ID: <b647ffbd0806080540w6dde917di1d7b812f01a4d81a@mail.gmail.com>
Date: Sun, 8 Jun 2008 14:40:29 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Subject: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...) is broken for some configs, e.g. CONFIG_SECURITY_SELINUX
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


the commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c has broken (always
-EINVAL as a return value)

prctl(PR_SET_KEEPCAPS, {1 | 0}, 0, 0, 0);


for the following configs:

1) CONFIG_SECURITY but without any of CONFIG_SECURITY_* modules;

2) CONFIG_SECURITY + CONFIG_SECURITY_SELINUX + CONFIG_SECURITY_SELINUX_DISABLE

both fall back to 'dummy' implementation.

3) CONFIG_SECURITY + CONFIG_SECURITY_SELINUX

for this config it will work when there is a secondary security module.


Here is what happens:

Processing of PR_SET_KEEPCAPS (and a couple of other options) has been
moved from kernel/sys.c::sys_prctl()
to security/commoncap.c::cap_task_prctl().

For the aforementioned configs cap_task_prctl() is not called
(moreover, security/commoncap.c is not compiled).

SELinux's implementation of .task_prctl callback resorts to
secondary_ops->task_prctl() which is dummy_task_prctl() (in the
absence of CONFIG_SECURITY_CAPABILITIES (or any other) as a secondary
module).


So the relevant code should be either moved back to sys_prctl() or
placed in some generic function (not in security/commoncap.c) which is
accessible for all configs.


p.s. perhaps, some would argue that such behavior might have its own
advantages. e.g. 'dhclient' on Ubuntu (for sure on 7.04) refuses to
work and, as a result, a crowd of Ubuntu followers turn their backs on
the virtual world and finally spend more time with their families. It
might be also good for the noble cause of fighting global warming...
heh, provided people don't escape into another virtual world by means
of shiny plasma-TVs :-)


-- 
Best regards,
Dmitry Adamushko
