Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbYKOLPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbYKOLPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 06:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYKOLPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 06:15:02 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbYKOLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 06:15:00 -0500
Subject: Re: drivers/video/backlight/mbp_nvidia_bl.c:114: error: storage
	size of '__mod_dmi_device_table' isn't known
From: David Woodhouse <dwmw2@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081114234131.GA28559@x200.localdomain>
References: <20081114234131.GA28559@x200.localdomain>
Content-Type: text/plain
Date: Sat, 15 Nov 2008 11:14:52 +0000
Message-Id: <1226747692.3687.285.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-15 at 02:41 +0300, Alexey Dobriyan wrote:
> How can this work, given that MODULE_DEVICE_TABLE line expands into
> 
>         extern const struct dmi_device_id __mod_dmi_device_table
> __attribute__ ((unused, alias("mbp_device_table")));
>                                 ^^^^^^
> but there is no struct dmi_device_id, there is struct dmi_system_id?

Interesting question ;)

It actually looks like this...

static struct dmi_system_id __initdata mbp_device_table[] = {
	...
};

extern const struct dmi_device_id __mod_dmi_device_table \
		__attribute__ ((unused, alias("mbp_device_table")));

So 'struct dmi_device_id' isn't ever really used -- it's just like a
forward declaration of a struct, and the compiler doesn't care because
it never needs to know anything more about that struct.

Not ideal though -- we should probably see if we can fix it. I suspect
it's not worth a global change of dmi_system_id to dmi_device_id
though... got any better ideas?

Maybe we could change MODULE_GENERIC_TABLE to be more agnostic about the
datatype -- just call it and 'extern char'. After all, it's only for the
linker.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

