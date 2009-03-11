Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZCKMZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZCKMZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZCKMZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:25:14 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56803 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755140AbZCKMZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:25:12 -0400
Date: Wed, 11 Mar 2009 13:25:09 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
In-Reply-To: <20090311010705.GA17260@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.00.0903111324400.1040@vixen.sonytel.be>
References: <49B6B821.5050302@oracle.com> <10f740e80903101256v2cfe08a8g410c297e019d8693@mail.gmail.com> <49B6C8BF.8010105@oracle.com> <20090310.131700.40129006.davem@davemloft.net> <20090311010705.GA17260@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Herbert Xu wrote:
> On Tue, Mar 10, 2009 at 01:17:00PM -0700, David Miller wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > Date: Tue, 10 Mar 2009 13:08:31 -0700
> > 
> > > I'll have to let David or Herbert answer that.  From my quick look
> > > at the code, I don't see much use for nlattr.c when CONFIG_NET
> > > is not enabled.
> > 
> > We want to use the netlink attribute parsers even in non-networking
> > code, that's what he's trying to do here.
> 
> OK the nlattr construction code really wants to depend on NET
> because they're skb-oriented.  We could either move them back
> or just wrap them in ifdef CONFIG_NET.
> 
> I think the latter is probably the simplest.
> 
> How does this patch look? And Randy, does it fix the problem for
> you?
> 
> nlattr: Fix build error with NET off
> 
> We moved the netlink attribute support from net to lib in order
> for it to be available for general consumption.  However, parts
> of the code (the bits that we don't need :) really depends on
> NET because the target object is sk_buff.
> 
> This patch fixes this by wrapping them in CONFIG_NET.
> 
> Some EXPORTs have been moved to make this work.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks for taking care of this!

Tested-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index 56c3ce7..80009a2 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -281,6 +281,7 @@ int nla_strcmp(const struct nlattr *nla, const char *str)
>  	return d;
>  }
>  
> +#ifdef CONFIG_NET
>  /**
>   * __nla_reserve - reserve room for attribute on the skb
>   * @skb: socket buffer to reserve room on
> @@ -305,6 +306,7 @@ struct nlattr *__nla_reserve(struct sk_buff *skb, int attrtype, int attrlen)
>  
>  	return nla;
>  }
> +EXPORT_SYMBOL(__nla_reserve);
>  
>  /**
>   * __nla_reserve_nohdr - reserve room for attribute without header
> @@ -325,6 +327,7 @@ void *__nla_reserve_nohdr(struct sk_buff *skb, int attrlen)
>  
>  	return start;
>  }
> +EXPORT_SYMBOL(__nla_reserve_nohdr);
>  
>  /**
>   * nla_reserve - reserve room for attribute on the skb
> @@ -345,6 +348,7 @@ struct nlattr *nla_reserve(struct sk_buff *skb, int attrtype, int attrlen)
>  
>  	return __nla_reserve(skb, attrtype, attrlen);
>  }
> +EXPORT_SYMBOL(nla_reserve);
>  
>  /**
>   * nla_reserve_nohdr - reserve room for attribute without header
> @@ -363,6 +367,7 @@ void *nla_reserve_nohdr(struct sk_buff *skb, int attrlen)
>  
>  	return __nla_reserve_nohdr(skb, attrlen);
>  }
> +EXPORT_SYMBOL(nla_reserve_nohdr);
>  
>  /**
>   * __nla_put - Add a netlink attribute to a socket buffer
> @@ -382,6 +387,7 @@ void __nla_put(struct sk_buff *skb, int attrtype, int attrlen,
>  	nla = __nla_reserve(skb, attrtype, attrlen);
>  	memcpy(nla_data(nla), data, attrlen);
>  }
> +EXPORT_SYMBOL(__nla_put);
>  
>  /**
>   * __nla_put_nohdr - Add a netlink attribute without header
> @@ -399,6 +405,7 @@ void __nla_put_nohdr(struct sk_buff *skb, int attrlen, const void *data)
>  	start = __nla_reserve_nohdr(skb, attrlen);
>  	memcpy(start, data, attrlen);
>  }
> +EXPORT_SYMBOL(__nla_put_nohdr);
>  
>  /**
>   * nla_put - Add a netlink attribute to a socket buffer
> @@ -418,6 +425,7 @@ int nla_put(struct sk_buff *skb, int attrtype, int attrlen, const void *data)
>  	__nla_put(skb, attrtype, attrlen, data);
>  	return 0;
>  }
> +EXPORT_SYMBOL(nla_put);
>  
>  /**
>   * nla_put_nohdr - Add a netlink attribute without header
> @@ -436,6 +444,7 @@ int nla_put_nohdr(struct sk_buff *skb, int attrlen, const void *data)
>  	__nla_put_nohdr(skb, attrlen, data);
>  	return 0;
>  }
> +EXPORT_SYMBOL(nla_put_nohdr);
>  
>  /**
>   * nla_append - Add a netlink attribute without header or padding
> @@ -454,20 +463,13 @@ int nla_append(struct sk_buff *skb, int attrlen, const void *data)
>  	memcpy(skb_put(skb, attrlen), data, attrlen);
>  	return 0;
>  }
> +EXPORT_SYMBOL(nla_append);
> +#endif
>  
>  EXPORT_SYMBOL(nla_validate);
>  EXPORT_SYMBOL(nla_parse);
>  EXPORT_SYMBOL(nla_find);
>  EXPORT_SYMBOL(nla_strlcpy);
> -EXPORT_SYMBOL(__nla_reserve);
> -EXPORT_SYMBOL(__nla_reserve_nohdr);
> -EXPORT_SYMBOL(nla_reserve);
> -EXPORT_SYMBOL(nla_reserve_nohdr);
> -EXPORT_SYMBOL(__nla_put);
> -EXPORT_SYMBOL(__nla_put_nohdr);
> -EXPORT_SYMBOL(nla_put);
> -EXPORT_SYMBOL(nla_put_nohdr);
>  EXPORT_SYMBOL(nla_memcpy);
>  EXPORT_SYMBOL(nla_memcmp);
>  EXPORT_SYMBOL(nla_strcmp);
> -EXPORT_SYMBOL(nla_append);

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
