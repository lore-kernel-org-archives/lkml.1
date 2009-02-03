Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZBCJPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZBCJPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZBCJOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:14:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZBCJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:14:37 -0500
Date: Tue, 3 Feb 2009 04:14:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] LinuxPPS core support.
Message-ID: <20090203091434.GB1091@infradead.org>
References: <1233510933-17512-1-git-send-email-giometti@linux.it> <1233510933-17512-2-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233510933-17512-2-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static long pps_cdev_ioctl(struct file *file,
> +		unsigned int cmd, unsigned long arg)
> +{
> +	struct pps_device *pps = file->private_data;
> +	struct pps_kparams params;
> +	struct pps_fdata fdata;
> +	unsigned long ticks;
> +	void __user *uarg = (void __user *) arg;
> +	int __user *iuarg = (int __user *) arg;
> +	int err;
> +
> +	switch (cmd) {
> +	case PPS_CHECK:
> +
> +		/* This does nothing but signal we are a PPS source... */
> +
> +		return 0;

I think this one is superflous.  Just doing a PPS_GETPARAMS: should get
your the same information..

> +	case PPS_GETPARAMS:
> +		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
> +
> +		/* Return current parameters */
> +		err = copy_to_user(uarg, &pps->params,
> +						sizeof(struct pps_kparams));
> +		if (err)
> +			return -EFAULT;
> +
> +		break;
> +
> +	case PPS_SETPARAMS:
> +		pr_debug("PPS_SETPARAMS: source %d\n", pps->id);
> +
> +		/* Check the capabilities */
> +		if (!capable(CAP_SYS_TIME))
> +			return -EPERM;
> +
> +		err = copy_from_user(&params, uarg, sizeof(struct pps_kparams));
> +		if (err)
> +			return -EFAULT;
> +		if (!(params.mode & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR))) {
> +			pr_debug("capture mode unspecified (%x)\n",
> +								params.mode);
> +			return -EINVAL;
> +		}

Note that splitting out any non-trivial ioctl into it's own small helper
function gives generally much cleaner code.

> +	if (pps_devt)
> +		unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);

Given that you have proper error handling in pps_init this can't
ever be zero.

> +
> +	pr_info("LinuxPPS API ver. %d removed\n", PPS_API_VERS);

Printing stuff on exit is rather noisy and should be avoided

