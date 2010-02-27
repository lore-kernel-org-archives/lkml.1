Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967716Ab0B0DCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 22:02:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36238 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532Ab0B0DCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 22:02:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rbqA9QjNAhY3df8LHKbmdH8z/rXJjpoPBbHc9HBrkgxXf0pMPV8qBlezQpDGNoIABh
         jWpPyR5Os7ZyRCsqN05b9NpgTEzj4/fxsK0NxsyHmJLMRYig6BnjTAX9plxrk6lVHhYP
         5RPC3jnUvwQppmOIC3YtRWHDrlDA6EQw8CU0Y=
MIME-Version: 1.0
In-Reply-To: <201002271052.AHB64003.OOQLJtFOHVFMSF@I-love.SAKURA.ne.jp>
References: <20100226144955.GB2778@localhost.localdomain>
	 <201002271052.AHB64003.OOQLJtFOHVFMSF@I-love.SAKURA.ne.jp>
Date: Sat, 27 Feb 2010 11:02:39 +0800
Message-ID: <628d1651002261902k6b22277dmfa93c01350c1aed6@mail.gmail.com>
Subject: Re: [PATCH] Security: Add __init to register_security to disable load 
	a security module on runtime
From: wzt wzt <wzt.wzt@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>That won't become a problem unless kernel command line is tampered.
>Giving permissions to tamper kernel command line is the problem.

The user also can modify /etc/selinuc/config, set SELINUX=disabled.

>Honestly speaking, I prefer register_security() being exported to kernel modules.

New kernel doesn't export register_security() to kernel modules
anymore.  For some reason the user disabled selinux, so the malicious
security modules have a chance to loaded on runtime.  LSM original
intention is not allowed to load security modules on runtime, right?
But if selinux is disabled, they can.

On Sat, Feb 27, 2010 at 9:52 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Zhitong Wang wrote:
>> LSM framework doesn't allow to load a security module on runtime, it must be loaded on boot time.
>> but in security/security.c:
>> int register_security(struct security_operations *ops)
>> {
>>         ...
>>         if (security_ops != &default_security_ops)
>>                 return -EAGAIN;
>>         ...
>> }
>> if security_ops == &default_security_ops, it can access to register a security module. If selinux is enabled,
>> other security modules can't register, but if selinux is disabled on boot time, the security_ops was set to
>> default_security_ops, LSM allows other kernel modules to use register_security() to register a not trust
>> security module. For example:
>>
>> disable selinux on boot time(selinux=0).
>
> That won't become a problem unless kernel command line is tampered.
> Giving permissions to tamper kernel command line is the problem.
>
> There are malicious security modules, but non malicious in-tree security
> modules are bothered by two limitations since register_security() is not
> exported to kernel modules since 2.6.24 .
>
> One is the size of vmlinux. Since all security modules have to be compiled
> into vmlinux, it makes difficult for distributors to include multiple security
> modules into vmlinux when there is vmlinux's size limitation. A well-known
> distributor is now considering including TOMOYO in addition to SELinux, but
> the size limitation of vmlinux seems to be the only problem that prevents
> inclusion.
>
> The other is the support provided by distributors. Another well-known
> distributor's support policy is that "We don't provide any support if vmlinux
> or kernel modules provided by us are recompiled. But we provide support if
> kernel modules provided by third party are used without modifying vmlinux and
> kernel modules provided by us." This means that the only way to allow users to
> use TOMOYO with distributor's support is to convince the distributor to include
> TOMOYO into vmlinux. This is a very difficult problem since the distributor
> recommends SELinux.
>
> Honestly speaking, I prefer register_security() being exported to kernel
> modules.
>
