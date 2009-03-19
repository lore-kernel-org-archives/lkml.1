Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZCSQHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZCSQHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZCSQHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:07:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZCSQHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:07:11 -0400
Message-ID: <49C26D91.10804@intel.com>
Date: Thu, 19 Mar 2009 09:06:41 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       maciej.sosnowski@intel.com, Ilya Yanok <yanok@emcraft.com>,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> + * @scfs: array of source coefficients used in GF-multiplication

Array of source coefficients?  Are you doing a vector-vector
multiplication here?

Given this code:

> 	for (d = 0; d < len; d++) {
> +		wq = wp = ptrs[0][d];
> +		for (z = 1; z < src_cnt; z++) {
> +			wd = ptrs[z][d];
> +			wp ^= wd;
> +			wq ^= raid6_gfmul[scfs[z]][wd];
> +		}

... it kinds of looks like that.

This is really quite expensive!  The whole point of the restore code
that exists is that we never do a two-dimensional lookup, instead
caching a pointer to the multiplication table that we intend to use,
because the RAID-6 code only ever contains scalar-vector multiplications.

I really don't get this, and I think it's broken.

	-hpa

