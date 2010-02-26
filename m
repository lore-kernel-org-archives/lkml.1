Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0BZKUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:20:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0BZKUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:20:20 -0500
Message-ID: <4B87A05A.3010600@redhat.com>
Date: Fri, 26 Feb 2010 12:20:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: SVM: Move msrpm offset calculation to seperate
 function
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com> <1267118149-15737-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267118149-15737-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2010 07:15 PM, Joerg Roedel wrote:
> The algorithm to find the offset in the msrpm for a given
> msr is needed at other places too. Move that logic to its
> own function.
>
>   #define MAX_INST_SIZE 15
>
> @@ -417,23 +439,22 @@ err_1:
>   static void set_msr_interception(u32 *msrpm, unsigned msr,
>   				 int read, int write)
>   {
> -	int i;
> +	u8 bit_read, bit_write;
> +	unsigned long tmp;
> +	u32 offset;
>
> -	for (i = 0; i<  NUM_MSR_MAPS; i++) {
> -		if (msr>= msrpm_ranges[i]&&
> -		    msr<  msrpm_ranges[i] + MSRS_IN_RANGE) {
> -			u32 msr_offset = (i * MSRS_IN_RANGE + msr -
> -					  msrpm_ranges[i]) * 2;
> -
> -			u32 *base = msrpm + (msr_offset / 32);
> -			u32 msr_shift = msr_offset % 32;
> -			u32 mask = ((write) ? 0 : 2) | ((read) ? 0 : 1);
> -			*base = (*base&  ~(0x3<<  msr_shift)) |
> -				(mask<<  msr_shift);
> -			return;
> -		}
> -	}
> -	BUG();
> +	offset    = svm_msrpm_offset(msr);
> +	bit_read  = 2 * (msr&  0x0f);
> +	bit_write = 2 * (msr&  0x0f) + 1;
> +
> +	BUG_ON(offset == MSR_INVALID);
> +
> +	tmp = msrpm[offset];
> +
> +	read  ? clear_bit(bit_read,&tmp) : set_bit(bit_read,&tmp);
> +	write ? clear_bit(bit_write,&tmp) : set_bit(bit_write,&tmp);
> +
> +	msrpm[offset] = tmp;
>   }
>    

This can fault - set_bit() accesses an unsigned long, which can be 8 
bytes, while offset can point into the last u32 of msrpm.  So this needs 
either to revert to u32 shift/mask ops or msrpm be changed to a ulong 
array (actually better, since bitmaps in general are defined as arrays 
of ulongs).

btw, the op-level ternary expression is terrible, relying solely on 
*_bit()'s side effects.  Please convert to an ordinary if.

btw2, use __set_bit() which atomic operation is not needed.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

