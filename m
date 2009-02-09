Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZBISMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZBISMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbZBISMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:12:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52283 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbZBISM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:12:29 -0500
Date: Mon, 9 Feb 2009 18:12:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, ben-linux@fluff.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/2] User access to internal clocks
Message-ID: <20090209181219.GC19453@n2100.arm.linux.org.uk>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 06:04:29PM +0100, Davide Rizzo wrote:
> +static ssize_t parent_store(struct device *dev,
> +       struct device_attribute *attr, const char *buffer, size_t count)
> +{
> +       struct clk *parent;
> +
> +       char *s = kstrdup(buffer, GFP_KERNEL);
> +
> +       if (!s)
> +               return -ENOMEM;
> +       if (s[strlen(s) - 1] == '\n')
> +               s[strlen(s) - 1] = '\0';
> +       parent = clk_get(dev, s);
> +       kfree(s);
> +       if (IS_ERR(parent))
> +               return PTR_ERR(parent);
> +
> +       mutex_lock(&mutex);
> +
> +       clk_set_parent(dev_get_drvdata(dev), parent);

BTW, MXC doesn't (and won't) support run-time changing of the clk tree.
OMAP sort-of does, but it's currently buggy.  It looks like S3C is also
buggy.

These implementations are currently only usable under a very strict set
of circumstances (which are not currently checked by the implementations)
and if the parent is changed while the clock is in use, it'll screw up
the clock tree - details below.

Arguably, that's a problem which the clk_set_parent() implementations need
to be solved (and I hope are going to be resolved), but it's an example
where exposing the API to allow userspace to fiddle with things produces
new ways to make things explode.  Certainly the MXC folk responded saying
"we don't support run-time parent changes".

FYI, the problem basically is that the sequence:

1. clk_enable(clk);
2. clk_set_parent(clk, new_parent);
3. clk_disable(clk);

will result in the old parent having a permanently incremented usecount,
and the new_parent having a negative usecount.  You could say "don't
permit enabled clocks to change parents" but I believe such a statement
would be provably incompatible with OMAP.

(This issue has just been pointed out to the relevant ARM maintainers
today.)
