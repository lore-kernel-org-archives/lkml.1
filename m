Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZD1Sd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZD1Sd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbZD1Sdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:33:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756729AbZD1Sdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:33:39 -0400
Date: Tue, 28 Apr 2009 11:30:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       borislav.petkov@amd.com
Subject: Re: [PATCH 19/21] amd64_edac: add debugging/testing code
Message-Id: <20090428113050.25f4b445.akpm@linux-foundation.org>
In-Reply-To: <1240931173-17477-20-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
	<1240931173-17477-20-git-send-email-borislav.petkov@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 17:06:11 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> This is for dumping different registers and testing the address mapping
> logic using the ECC syndromes.
> 
>
> ...
>
> +static ssize_t amd64_nbea_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long long value;
> +	int rc;
> +
> +	rc = strict_strtoull(data, 16, &value);
> +	if (rc != -EINVAL) {
> +		debugf0("%s() received NBEA= 0x%llx\n", __func__, value);
> +
> +		/* place the value into the virtual error packet */
> +		pvt->ctl_error_info.nbeal = (u32) value;
> +		value >>= 32;
> +		pvt->ctl_error_info.nbeah = (u32) value;
> +
> +		/* Process the Mapping request */
> +		/* TODO: Add race preventation */
> +		amd64_process_error_info(mci, &pvt->ctl_error_info, 1);
> +
> +		return count;
> +	}
> +	return 0;

I think we want to return `rc' here, not zero?

> +}
> +
> +/*
> + * amd64_nbea_show
> + *
> + *	display back what the last NBEA address was written
> + */
> +static ssize_t amd64_nbea_show(struct mem_ctl_info *mci, char *data)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	u64 value;
> +
> +	value = pvt->ctl_error_info.nbeah;
> +	value <<= 32;
> +	value |= pvt->ctl_error_info.nbeal;
> +
> +	return sprintf(data, "%lx\n", (unsigned long) value);

fyi, you could simply do

	return sprintf(data, "%llx\n", value);

here (and in all the other places).  `u64' will always be implemented
as `unsigned long long' on this architecture.  One day _all_ 64-bit
architectures will use ull for u64 and zillions of these typecasts will
no longer be needed.  You'll be safe preparing for that day in this
driver ;)

> +}
> +
> +/*
> + * amd64_nbsl_store
> + *
> + *	accept and store the NBSL value user desires
> + */
> +static ssize_t amd64_nbsl_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 16, &value);
> +	if (rc != -EINVAL) {
> +		debugf0("%s() received NBSL= 0x%lx\n", __func__, value);
> +
> +		/* place the NBSL value into the virtual error packet */
> +		pvt->ctl_error_info.nbsl = (u32) value;
> +
> +		return count;
> +	}
> +	return 0;

Again, this should report the error.

> +}
> +
>
> ...
>
> +/*
> + * amd64_nbsh_store
> + *
> + *	accept and store the NBSH value user desires
> + */
> +static ssize_t amd64_nbsh_store(struct mem_ctl_info *mci,
> +					const char *data, size_t count)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	unsigned long value;
> +	int rc;
> +
> +	rc = strict_strtoul(data, 16, &value);
> +	if (rc != -EINVAL) {
> +		debugf0("%s() received NBSL= 0x%lx\n", __func__, value);
> +
> +		/* place the NBSL value into the virtual error packet */
> +		pvt->ctl_error_info.nbsh = (u32) value;
> +
> +		return count;
> +	}

Many instances...

> +	return 0;
> +}
> +
>
> ...
>
> +static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
> +{
> +	u64 hole_base = 0;
> +	u64 hole_offset = 0;
> +	u64 hole_size = 0;
> +
> +	amd64_get_dram_hole_info(mci, &hole_base, &hole_offset, &hole_size);
> +
> +	return sprintf(data, "%lx %lx %lx\n",
> +		(long unsigned int) hole_base,
> +		(long unsigned int) hole_offset,
> +		(long unsigned int) hole_size);

hm, odd.  We'd normally use plain old `unsigned long' here.  But as
mentioned above, we can remove these casts.

> +}
>
> ...
>

