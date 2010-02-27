Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966882Ab0B0Bwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 20:52:34 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:60213 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966829Ab0B0Bwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 20:52:33 -0500
To: wzt.wzt@gmail.com, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org
Subject: Re: [PATCH] Security: Add __init to register_security to disable load a security module on runtime
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100226144955.GB2778@localhost.localdomain>
In-Reply-To: <20100226144955.GB2778@localhost.localdomain>
Message-Id: <201002271052.AHB64003.OOQLJtFOHVFMSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 27 Feb 2010 10:52:30 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhitong Wang wrote:
> LSM framework doesn't allow to load a security module on runtime, it must be loaded on boot time.
> but in security/security.c:
> int register_security(struct security_operations *ops)
> {
>         ...
>         if (security_ops != &default_security_ops)
>                 return -EAGAIN;
>         ...
> }
> if security_ops == &default_security_ops, it can access to register a security module. If selinux is enabled,
> other security modules can't register, but if selinux is disabled on boot time, the security_ops was set to
> default_security_ops, LSM allows other kernel modules to use register_security() to register a not trust
> security module. For example:
> 
> disable selinux on boot time(selinux=0).

That won't become a problem unless kernel command line is tampered.
Giving permissions to tamper kernel command line is the problem.

There are malicious security modules, but non malicious in-tree security
modules are bothered by two limitations since register_security() is not
exported to kernel modules since 2.6.24 .

One is the size of vmlinux. Since all security modules have to be compiled
into vmlinux, it makes difficult for distributors to include multiple security
modules into vmlinux when there is vmlinux's size limitation. A well-known
distributor is now considering including TOMOYO in addition to SELinux, but
the size limitation of vmlinux seems to be the only problem that prevents
inclusion.

The other is the support provided by distributors. Another well-known
distributor's support policy is that "We don't provide any support if vmlinux
or kernel modules provided by us are recompiled. But we provide support if
kernel modules provided by third party are used without modifying vmlinux and
kernel modules provided by us." This means that the only way to allow users to
use TOMOYO with distributor's support is to convince the distributor to include
TOMOYO into vmlinux. This is a very difficult problem since the distributor
recommends SELinux.

Honestly speaking, I prefer register_security() being exported to kernel
modules.
