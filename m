Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbYEVFmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbYEVFmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 01:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYEVFmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 01:42:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbYEVFmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 01:42:01 -0400
Date: Wed, 21 May 2008 22:41:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] security: protect legacy apps from insufficient
 privilege
Message-Id: <20080521224137.8d5c0089.akpm@linux-foundation.org>
In-Reply-To: <483444C1.6050308@kernel.org>
References: <483444C1.6050308@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 08:50:25 -0700 "Andrew G. Morgan" <morgan@kernel.org> wrote:

> +	CAP_FOR_EACH_U32(i) {
> +		if (i >= tocopy) {
> +			/*
> +			 * Legacy capability sets have no upper bits
> +			 */
> +			bprm->cap_post_exec_permitted.cap[i] = 0;
> +		} else {
> +			__u32 value_cpu;
> +			/*
> +			 * pP' = (X & fP) | (pI & fI)
> +			 */
> +			value_cpu = le32_to_cpu(caps->data[i].permitted);
> +			bprm->cap_post_exec_permitted.cap[i] = (
> +					current->cap_bset.cap[i] & value_cpu
> +				) | (
> +					current->cap_inheritable.cap[i] &
> +					le32_to_cpu(caps->data[i].inheritable)
> +				);
> +			if (value_cpu &
> +			    ~bprm->cap_post_exec_permitted.cap[i]) {
> +				/*
> +				 * insufficient to execute correctly
> +				 */
> +				ret = -EPERM;
> +			}
> +		}
>  	}

That makes my eyes say ow.  The 80-col thing is a pain.

With a judiciously placed `continue' we can do this:

	CAP_FOR_EACH_U32(i) {
		__u32 value_cpu;

		if (i >= tocopy) {
			/*
			 * Legacy capability sets have no upper bits
			 */
			bprm->cap_post_exec_permitted.cap[i] = 0;
			continue;
		}
		/*
		 * pP' = (X & fP) | (pI & fI)
		 */
		value_cpu = le32_to_cpu(caps->data[i].permitted);
		bprm->cap_post_exec_permitted.cap[i] =
			(current->cap_bset.cap[i] & value_cpu) |
			(current->cap_inheritable.cap[i] &
				le32_to_cpu(caps->data[i].inheritable));
		if (value_cpu & ~bprm->cap_post_exec_permitted.cap[i]) {
			/*
			 * insufficient to execute correctly
			 */
			ret = -EPERM;
		}
	}

OK?
