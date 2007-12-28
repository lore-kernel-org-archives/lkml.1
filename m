Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbXL1JNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbXL1JNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 04:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXL1JNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 04:13:14 -0500
Received: from namei.org ([69.55.235.186]:50725 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752050AbXL1JNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 04:13:13 -0500
Date: Fri, 28 Dec 2007 20:12:32 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@osdl.org, morgan@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
In-Reply-To: <477494C3.2040301@ak.jp.nec.com>
Message-ID: <Xine.LNX.4.64.0712281957520.23510@us.intercode.com.au>
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com>
 <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007, KaiGai Kohei wrote:

> Remaining issues:
> - We have to mount securityfs explicitly, or use /etc/fstab.
>   It can cause a matter when we want to use this feature on
>   very early phase on boot. (like /sbin/init)

Why can't early userspace itself mount securityfs?

I'm not even sure this is a good idea at all.  Existing capabilities will 
never disappear, and, as with syscalls, it's probably up to userland to 
handle new ones not existing.

In any case, some more technical issues:

> kernel/cap_names.sh generates the body of cap_entries[] array,

This needs to be in the scripts directory.

The generated header should be made idempotent (#ifdef wrapping), and also 
include a warning that it is automatically generated (identifying the 
script which does so), and that is should not be edited.

> +	d_caps = securityfs_create_dir("capability", NULL);
> +	if (!d_caps)

Wrong way to check for error -- the function returns an ERR_PTR().

> +		f_caps[i] = securityfs_create_file(cap_entries[i].name, 0444,
> +						   d_caps, &cap_entries[i],
> +						   &cap_entry_fops);
> +		if (!f_caps[i])

Ditto.

Another issue is that securityfs depends on CONFIG_SECURITY, which might 
be undesirable, given that capabilities are a standard feature.


- James
-- 
James Morris
<jmorris@namei.org>
