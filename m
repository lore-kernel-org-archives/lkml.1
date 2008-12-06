Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbYLFFEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbYLFFEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 00:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbYLFFEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 00:04:14 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:59889 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYLFFEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 00:04:13 -0500
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mtk.manpages@googlemail.com
Subject: MAC and pam_nologin (was Re: man-pages-3.15 is released)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <493A01E0.1070705@gmail.com>
In-Reply-To: <493A01E0.1070705@gmail.com>
Message-Id: <200812061404.EJG35994.MOJOFQFOLFHtVS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 6 Dec 2008 14:04:07 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The "man 5 nologin" says that:

  If the file /etc/nologin *exists*, login (1) will allow access only to root.
  Other users will be shown the contents of this file and their logins will be
  refused.

But this description becomes inaccurate when MAC (e.g. SELinux) is enabled.

MAC can deny open("/etc/nologin", O_RDONLY) by root user. Thus,

  # ln /etc/shadow /etc/nologin

will create /etc/nologin which is *not readable* by login(1).
As a result, non-root user's logins are permitted while /etc/nologin *exists*.

I guess pam_nologin is using a code like

  fp = fopen("/etc/nologin", "r");
  if (fp)
     /* print the contents of /etc/nologin and reject login request. */

So, I think either one of below modifications is needed.

(1) Change the description of manpage like

  If the file /etc/nologin *is readable*, login (1) will allow access only to
  root. Other users will be shown the contents of this file and their logins
  will be refused.

(2) Change the code of pam_nologin like

  fd = open("/etc/nologin", O_RDONLY);
  if (fd != EOF || errno != ENOENT)
     /* print the contents of /etc/nologin and reject login request. */

Which one is the better solution?

Regards.
