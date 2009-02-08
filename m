Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZBHL1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZBHL1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 06:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZBHL1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 06:27:09 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57357 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZBHL1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 06:27:08 -0500
Date: Sun, 8 Feb 2009 04:26:51 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI/MSI: fix msi_mask()
Message-ID: <20090208112650.GD31509@parisc-linux.org>
References: <498A5348.3090508@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498A5348.3090508@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 11:47:36AM +0900, Hidetoshi Seto wrote:
> The commit bffac3c593eba1f9da3efd0199e49ea6558a40ce does:
> 
>  -    temp = (1 << multi_msi_capable(control));
>  -    temp = ((temp - 1) & ~temp);
>  +    temp = msi_mask((control & PCI_MSI_FLAGS_QMASK) >> 1);
> 
> and provides msi_mask() to avoid undefined shift by 32.
[...]
> This patch fix the wrong array in the msi_mask().

Quite correct.  While disconnected for a couple of weeks, I also
considered this possible fix:

static inline __attribute_const__ u32 msi_mask(unsigned x)
{
        /* Don't shift by >= width of type */
        if (x >= 5)
                return 0xffffffff;
        return (1 << (1 << x)) - 1;
}

which has the added bonus of not running off the end of the array if
some device has a bogus value in its config space.

What do you think?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
