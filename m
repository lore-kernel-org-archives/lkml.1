Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZH0LtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZH0LtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZH0LtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:49:10 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47305 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZH0LtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AJLcv7KZ6icR3iufxrtQKNBdwo5sjBODD7pTVuLuPkGfI5xipS9/IStACUgv7v2fOp
         4W716qZ8nzKHBU/lIDvckOkko7l2ABOTQwdzWdBjB/7iRSpnYYNXVB6rsQrZTi6zXrXi
         eDc9OuxMTBwv97USWcb4Zb61/x4DPvE7f8VEU=
Message-ID: <4A9672A5.60004@gnu.org>
Date: Thu, 27 Aug 2009 13:48:53 +0200
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davidel@xmailserver.org, avi@redhat.com, gleb@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] eventfd: reorganize the code to simplify new flags
References: <cover.1250783333.git.mst@redhat.com> <20090820155703.GB8764@redhat.com>
In-Reply-To: <20090820155703.GB8764@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 05:57 PM, Michael S. Tsirkin wrote:
> +static inline int eventfd_writeable(struct eventfd_ctx *ctx, u64 n)
> +{
> +	return ULLONG_MAX - n>  ctx->count;
> +}
> +
> +static inline void eventfd_dowrite(struct eventfd_ctx *ctx, u64 ucnt)
> +{
> +	if (eventfd_writeable(ctx, ucnt))
> +		ucnt = ULLONG_MAX - ctx->count;
> +
> +	ctx->count += ucnt;

In any case, this usage of eventfd_writeable is wrong: the code was like 
this:

-	if (ULLONG_MAX - ctx->count < n)
-		n = (int) (ULLONG_MAX - ctx->count);
-	ctx->count += n;
+	eventfd_dowrite(ctx, n);

and so it should be !eventfd_writable.  (This smelled when I was editing 
patch 2, so I went back and checked patch 1).

Paolo
