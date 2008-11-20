Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYKTVWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYKTVWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYKTVW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:22:27 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49166 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbYKTVW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:22:26 -0500
Subject: Re: [PATCH 3/4] integrity: IMA as an integrity service provider
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <342f87b65eae2369d96501d8d4935d6be0f46678.1227137423.git.zohar@linux.vnet.ibm.com>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
	 <342f87b65eae2369d96501d8d4935d6be0f46678.1227137423.git.zohar@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 13:22:21 -0800
Message-Id: <1227216141.11607.22.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 11:43 -0500, Mimi Zohar wrote:
> 
> +       /* Invalidate PCR, if a measured file is already open for read
> */
> +       if ((mask == MAY_WRITE) || (mask == MAY_APPEND)) {
> +               int mask_sav = data->mask;
> +               int rc;
> +
> +               data->mask = MAY_READ;
> +               rc = ima_must_measure(&idata);
> +               if (!rc) {
> +                       if (atomic_read(&(data->dentry->d_count)) - 1 >
> +                           atomic_read(&(inode->i_writecount)))
> +                               ima_add_violation(inode, data->filename,
> +                                                 "invalid_pcr", "ToMToU");
> +               }
> +               data->mask = mask_sav;
> +               goto out;
> +       }

Following up on Christoph's comment...

I'm worried that this calculation isn't very precise.  The calculation
that you're trying to come up with here is the number of opens (d_count)
vs. the number of writers (i_writecount).  When they don't match, you
know that the new open is the first write, and you must 'invalidate the
PCR'?

There are a number of things that elevate d_count, and it is a lot more
than just an open() that can do it.  Is that OK?

-- Dave

