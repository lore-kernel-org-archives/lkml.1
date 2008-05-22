Return-Path: <linux-kernel-owner+w=401wt.eu-S932549AbYEVLos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbYEVLos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbYEVLoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:44:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32876 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbYEVLog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:44:36 -0400
Subject: Re: [PATCH 3/4] modules: proper cleanup of kobject without
	CONFIG_SYSFS
From: "Denis V. Lunev" <den@openvz.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <200805221920.22920.rusty@rustcorp.com.au>
References: <1211277589-8565-1-git-send-email-den@openvz.org>
	 <1211277589-8565-3-git-send-email-den@openvz.org>
	 <200805221920.22920.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Thu, 22 May 2008 15:44:21 +0400
Message-Id: <1211456661.7496.6.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 19:20 +1000, Rusty Russell wrote:
> On Tuesday 20 May 2008 19:59:48 Denis V. Lunev wrote:
> > kobject: '<NULL>' (ffffffffa0104050): is not initialized, yet kobject_put()
> 
> Thanks Denis.
> 
> This patch masks a deeper problem; looks like you can't load any modules with 
> CONFIG_SYSFS=n:
> 
> kernel/module.c:
> int mod_sysfs_init(struct module *mod)
> {
> 	int err;
> 	struct kobject *kobj;
> 
> 	if (!module_sysfs_initialized) {
> 		printk(KERN_ERR "%s: module sysfs not initialized\n",
> 		       mod->name);
> 		err = -EINVAL;
> 		goto out;
> 	}
> 
> AFAICT, module_sysfs_initialized is not ever set if !CONFIG_SYSFS.
> 
> I can't see the point of module_sysfs_initialized.  It was introduced by Greg 
> in commit 823bccfc ("remove "struct subsystem" as it is no longer needed").
> 
> Greg, what were you trying to do here?  Modules can't be loaded before 
> param_sysfs_init(): are you trying to handle the case where the 
> kset_create_and_add() fails?

Basically you miss
static inline int mod_sysfs_init(struct module *mod)
{
        return 0;
}
in include/linux/module.h

So, without CONFIG_SYSFS a dummy stab for mod_sysfs_init is called.

Regards,
	Den

