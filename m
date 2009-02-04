Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbZBDBuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbZBDBuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZBDBub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:50:31 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:29571 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZBDBua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:50:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H0O1e+XmcgS15z/k0UfEJYg0+TxWtdDZAaB7N4a25X7duL+Io2jFhIaAZqlEGc/+c6
         QlgBCf6LR0CJ03X8Wgwp8MsEYKyQSfILiwGkMh1rTD9fr3++QmeqtJIIFU5GFI1CiZhA
         WSTYcfv10sO+jgOR6ywSzUSVFzPAZthZkKAxk=
Subject: Re: [PATCH] net/9p: fix endian issues
From: Harvey Harrison <harvey.harrison@gmail.com>
To: ericvh@gmail.com
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1233676289-1933-1-git-send-email-ericvh@gmail.com>
References: <1233676289-1933-1-git-send-email-ericvh@gmail.com>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 17:50:26 -0800
Message-Id: <1233712226.5752.32.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 09:51 -0600, ericvh@gmail.com wrote:
> From: Eric Van Hensbergen <ericvh@gmail.com>
> 
> When the changes were done to the protocol last release, some endian
> bugs crept in.  This patch fixes those endian problems and has been
> verified to run on 32/64 bit and x86/ppc architectures.
> 
> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> ---
>  net/9p/protocol.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/9p/protocol.c b/net/9p/protocol.c
> index dcd7666..19ad5d2 100644
> --- a/net/9p/protocol.c
> +++ b/net/9p/protocol.c
> @@ -164,7 +164,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
>  					errcode = -EFAULT;
>  					break;
>  				}
> -				*val = cpu_to_le16(*val);
> +				*val = le16_to_cpu(*val);
>  			}
>  			break;
>  		case 'd':{
> @@ -173,7 +173,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
>  					errcode = -EFAULT;
>  					break;
>  				}
> -				*val = cpu_to_le32(*val);
> +				*val = le32_to_cpu(*val);
>  			}
>  			break;
>  		case 'q':{
> @@ -182,7 +182,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
>  					errcode = -EFAULT;
>  					break;
>  				}
> -				*val = cpu_to_le64(*val);
> +				*val = le64_to_cpu(*val);
>  			}

Umm, the above three have absolutely no functional effect you know.  And you're just
trading one set of sparse warnings for another.

>  			break;
>  		case 's':{
> @@ -362,19 +362,19 @@ p9pdu_vwritef(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
>  			}
>  			break;
>  		case 'w':{
> -				int16_t val = va_arg(ap, int);
> +				int16_t val = cpu_to_le16(va_arg(ap, int));
>  				if (pdu_write(pdu, &val, sizeof(val)))
>  					errcode = -EFAULT;
>  			}
>  			break;
>  		case 'd':{
> -				int32_t val = va_arg(ap, int32_t);
> +				int32_t val = cpu_to_le32(va_arg(ap, int32_t));
>  				if (pdu_write(pdu, &val, sizeof(val)))
>  					errcode = -EFAULT;
>  			}
>  			break;
>  		case 'q':{
> -				int64_t val = va_arg(ap, int64_t);
> +				int64_t val = cpu_to_le64(va_arg(ap, int64_t));
>  				if (pdu_write(pdu, &val, sizeof(val)))
>  					errcode = -EFAULT;
>  			}

And here even if you are fixing endian bugs, you're actively _introducing_
sparse warnings, it would be nice if you could annotate the variable types
properly too.

Cheers,

Harvey

