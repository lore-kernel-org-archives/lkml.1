Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436Ab0AYXyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0AYXyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805Ab0AYXyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:54:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab0AYXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:54:43 -0500
Date: Mon, 25 Jan 2010 15:52:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Gaetan Nadon <memsize@videotron.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] pci: Update pci_set_vga_state to call arch
 functions
Message-Id: <20100125155234.a2e397a1.akpm@linux-foundation.org>
In-Reply-To: <20100118183418.045021000@alcatraz.americas.sgi.com>
References: <20100118183412.560438000@alcatraz.americas.sgi.com>
	<20100118183418.045021000@alcatraz.americas.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 12:34:13 -0600
Mike Travis <travis@sgi.com> wrote:

> Update pci_set_vga_state to call arch dependent functions to enable
> Legacy VGA I/O transactions to be redirected to correct target.
> 

Changelog doesn't explain the reason for doing this, but it looks like
that becomes clearer in later patches.

>  
> +/* Some architectures require additional programming to enable VGA */
> +static arch_set_vga_state_t arch_set_vga_state;
> +
> +void pci_register_set_vga_state(arch_set_vga_state_t func)
> +{
> +	arch_set_vga_state = func;	/* NULL disables */
> +}
> +
> +static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
> +		      unsigned int command_bits, bool change_bridge)
> +{
> +	if (arch_set_vga_state)
> +		return arch_set_vga_state(dev, decode, command_bits,
> +						change_bridge);
> +	return 0;
> +}

hm, that's not terribly elegant.  It's racy too, although it seems
unlikely that an arch will call pci_set_vga_state_arch() more than
once.

Still, a neater solution might be

int arch_pci_set_vga_state(...) __weak
{
	return 0;
}

and then resolve it at linkage time?


