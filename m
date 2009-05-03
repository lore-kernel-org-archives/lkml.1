Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZECGoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZECGoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 02:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZECGoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 02:44:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33858 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZECGoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 02:44:34 -0400
Date: Sun, 3 May 2009 07:44:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via
	eventfd-notification interface
Message-ID: <20090503064432.GS8633@ZenIV.linux.org.uk>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427183334.6646.90800.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:33:34PM -0400, Gregory Haskins wrote:
> +	/* We re-use eventfd for irqfd */
> +	fd = sys_eventfd2(0, 0);
> +	if (fd < 0) {
> +		ret = fd;
> +		goto fail;
> +	}
> +
> +	/* We maintain a reference to eventfd for the irqfd lifetime */
> +	file = eventfd_fget(fd);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	irqfd->file = file;

This is just plain wrong.  You have no promise whatsoever that caller of
that sucker won't race with e.g. dup2().  IOW, you can't assume that
file will be of the expected kind.
