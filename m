Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbYEUAsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbYEUAsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYEUAsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:48:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:3625 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbYEUAsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xcpn7NTM/SubMctJG2yUyP1bfYPPwX1PBQiJuLcHPyYT5QDY1IYcPaeSEg8nXyFC2Df0dGmG5scMAuN0ykpNU+Nz9JbtWDpCpHia+0dHfD3VBLR7772mRCTTpzqxFE0cyWEs3mMMCOB2Y1EAxqZdS1K8XA27u0eoRHjrC+yKJa4=
Subject: Re: [PATCH] misc drivers/net endianness noise
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080521003430.GB28946@ZenIV.linux.org.uk>
References: <20080521003430.GB28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 20 May 2008 17:48:00 -0700
Message-Id: <1211330880.5915.236.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:34 +0100, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  	tx_buf = catc->tx_buf[catc->tx_idx] + catc->tx_ptr;
> -	*((u16*)tx_buf) = (catc->is_f5u011) ? cpu_to_be16((u16)skb->len) : cpu_to_le16((u16)skb->len);
> +	if (catc->is_f5u011)
> +		*(__be16 *)tx_buf = cpu_to_be16(skb->len);
> +	else
> +		*(__le16 *)tx_buf = cpu_to_le16(skb->len);
>  	skb_copy_from_linear_data(skb, tx_buf + 2, skb->len);

I was contemplating an api like:

void put_le16(u16 val, __le16 *ptr)
{
	*ptr = cpu_to_le16(val);
}

which would allow the above to become:

	if (catc->is_f5u011)
		put_be16(skb->len, tx_buf);
	else
		put_le16(skb->len, tx_buf);

Thoughts?

Harvey

