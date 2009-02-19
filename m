Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbZBSMJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbZBSMJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbZBSMIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:08:40 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:23421 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758492AbZBSMIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:08:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MEof338oBQOsO2YnjZR/wcwNVXe7AU6MaYLyVJcHn8H9MfS+j94tHyt27oQnn9qqgDiRHpj7TwsVo17aO0dKR0knjE72b/BnMuM+oBatZaNprICZJVm7zV4kFJUdPvZwLaT3jB+HsJOtGXZL948BZ1wyPIEyKiTsAxkoU0adgO0=  ;
X-YMail-OSG: OjS1UyMVM1l88hcvHJIQCCDh46wSVW.0nQQvzDc3rcKhTIuwXHxHzMn1Hf01IIri_5v9QxV00WxXOZeSIWDjnZhqkx9KeDnFmKhkBtqJoPSL_eBn92f74ZHzCZ.pzxZE.8h5WvQNF6DfhzB5Mee5sSRNIF4IMavZ.lbAEkHxVsJT5RadVhuNDY8aIWSE
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/10] module: fix out-of-range memory access
Date: Thu, 19 Feb 2009 23:08:04 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-3-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192308.05679.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 23:04:28 Tejun Heo wrote:
> Impact: subtle memory access bug fix
>
> percpu_modalloc() may access pcpu_size[-1].  The access won't change
> the value by itself but it still is read/write access and dangerous.
> Fix it.

Ditto for this one...

>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/module.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index ba22484..d54a63e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -426,12 +426,14 @@ static void *percpu_modalloc(unsigned long size,
> unsigned long align, continue;
>
>  		/* Transfer extra to previous block. */
> -		if (pcpu_size[i-1] < 0)
> -			pcpu_size[i-1] -= extra;
> -		else
> -			pcpu_size[i-1] += extra;
> -		pcpu_size[i] -= extra;
> -		ptr += extra;
> +		if (extra) {
> +			if (pcpu_size[i-1] < 0)
> +				pcpu_size[i-1] -= extra;
> +			else
> +				pcpu_size[i-1] += extra;
> +			pcpu_size[i] -= extra;
> +			ptr += extra;
> +		}
>
>  		/* Split block if warranted */
>  		if (pcpu_size[i] - size > sizeof(unsigned long))


