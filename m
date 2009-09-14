Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbZINGjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbZINGjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZINGjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:39:12 -0400
Received: from centrinvest.ru ([94.25.115.130]:51384 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZINGjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:39:11 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Mon, 14 Sep 2009 10:39:11 +0400
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] kernel handling of memory DLPAR
Message-ID: <20090914063911.GB13139@centrinvest.ru>
Mail-Followup-To: Nathan Fontenot <nfont@austin.ibm.com>,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <4AAABC55.4070207@austin.ibm.com>
 <4AAABDBB.7010400@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAABDBB.7010400@austin.ibm.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 254, 09 11, 2009 at 04:14:35PM -0500, Nathan Fontenot wrote:
> This adds the capability to DLPAR add and remove memory from the kernel.  The
> patch extends the powerpc handling of memory_add_physaddr_to_nid(), which is
> called from the sysfs memory 'probe' file to first ensure that the memory
> has been added to the system.  This is done by creating a platform specific
> callout from the routine.  The pseries implementation of this handles the
> DLPAR work to add the memory to the system and update the device tree.
> 
> The patch also creates a pseries only 'release' sys file,
> /sys/devices/system/memory/release.  This file handles the DLPAR
> release of
> memory back to firmware and updating of the device-tree.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

> +static struct property *clone_property(struct property *old_prop)
> +{
> +	struct property *new_prop;
> +
> +	new_prop = kzalloc((sizeof *new_prop), GFP_KERNEL);
> +	if (!new_prop)
> +		return NULL;
> +
> +	new_prop->name = kzalloc(strlen(old_prop->name) + 1, GFP_KERNEL);
> +	new_prop->value = kzalloc(old_prop->length + 1, GFP_KERNEL);

Memory leak here. What if one kzalloc() succeeded and another failed ?

> +	if (!new_prop->name || !new_prop->value) {
> +		free_property(new_prop);
> +		return NULL;
> +	}
> +
> +	strcpy(new_prop->name, old_prop->name);
> +	memcpy(new_prop->value, old_prop->value, old_prop->length);
> +	new_prop->length = old_prop->length;
> +
> +	return new_prop;
> +}
