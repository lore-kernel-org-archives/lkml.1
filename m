Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZBFXWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZBFXWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZBFXWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:22:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbZBFXWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:22:11 -0500
Date: Fri, 6 Feb 2009 15:21:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] Soekris net5501 board support code
Message-Id: <20090206152121.3ae5208a.akpm@linux-foundation.org>
In-Reply-To: <20090205161319.32219d93@i1501.lan.towertech.it>
References: <20090205161319.32219d93@i1501.lan.towertech.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 16:13:19 +0100
Alessandro Zummo <alessandro.zummo@towertech.it> wrote:

> +static int __init soekris_init(void)
> +{
> +	int i;
> +	unsigned char *rombase, *bios;
> +
> +	if (!is_geode() || geode_has_vsa2())
> +		return 0;
> +
> +	rombase = ioremap(0xffff0000, 0xffff);
> +	if (!rombase)
> +		return 0;

Is it appropriate to silently "succeed" if the ioremap() failed?

> +	bios = rombase + 0x20;	/* null terminated */
> +
> +	if (strncmp(bios, "comBIOS", 7))
> +		goto unmap;
> +
> +	for (i = 0; i < ARRAY_SIZE(boards); i++) {
> +		unsigned char *model = rombase + boards[i].offset;
> +
> +		if (strncmp(model, boards[i].sig, boards[i].len) == 0) {
> +			printk(KERN_INFO "Soekris %s: %s\n", model, bios);
> +
> +			if (boards[i].init)
> +				boards[i].init();
> +			break;
> +		}
> +	}
> +
> +unmap:
> +	iounmap(rombase);
> +	return 0;
