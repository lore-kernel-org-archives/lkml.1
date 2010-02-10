Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0BJBWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:22:00 -0500
Received: from smtp-out.google.com ([216.239.33.17]:1447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0BJBV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:21:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FQRmHQobOVvNCP93nI6OdKcLTfWpw5vlKD/jaRgV0vsBsaFLg5yyY9HaDAhu4ieuh
	HjMAlvSgOAB9HfartwD3Q==
Date: Tue, 9 Feb 2010 17:21:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Neil Brown <neilb@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate  between locking links and
 non-links
In-Reply-To: <19314.1869.847327.15190@notabene.brown>
Message-ID: <alpine.DEB.2.00.1002091716580.13999@chino.kir.corp.google.com>
References: <19314.1869.847327.15190@notabene.brown>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010, Neil Brown wrote:

> commit 2e502cfe444b68f6ef6b8b2abe83b6112564095b
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed Feb 10 09:43:45 2010 +1100
> 
>     sysfs: differentiate  between locking links and non-links for sysfs
>     
>     symlinks and non-symlink is sysfs are very different.
>     A symlink can never be locked (active) while an attribute
>     modification routine is running.  So removing symlink from an
>     attribute 'store' routine should be permitted without any lockdep
>     warnings.
>     
>     So split the lockdep context for 's_active' in two, one for symlinks
>     and other for everything else.
>     

What happens for hard links such as writing to 
/sys/devices/block/xxx/queue/scheduler to change an I/O scheduler which 
requires sd->dep_map and sd->parent->dep_map in sysfs_get_active_two() to 
pin both?  The call to kobject_del() invokes the destruction that also 
requires sd->dep_map in sysfs_deactivate() because of the s_active lockdep 
annotation.

This is the scenario that is presented in
http://bugzilla.kernel.org/show_bug.cgi?id=15202.
