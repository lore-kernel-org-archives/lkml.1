Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYLVX50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYLVX50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYLVX5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:57:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbYLVX5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:57:17 -0500
Date: Tue, 23 Dec 2008 00:54:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 4/6][v3] Define siginfo_from_ancestor_ns()
Message-ID: <20081222235458.GA7279@redhat.com>
References: <20081221005106.GA4912@us.ibm.com> <20081221005424.GD5025@us.ibm.com> <20081222222604.GA1536@redhat.com> <20081222234524.GB13079@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222234524.GB13079@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22, Sukadev Bhattiprolu wrote:
>
> Oleg Nesterov [oleg@redhat.com] wrote:
> | On 12/20, Sukadev Bhattiprolu wrote:
> | >
> | > + * TODO:
> | > + * 	  Making SI_ASYNCIO a kernel signal could make this less hacky.
> | > + */
> | > +#ifdef CONFIG_PID_NS
> | > +static inline int siginfo_from_user(siginfo_t *info)
> | > +{
> | > +	if (!is_si_special(info) && SI_FROMUSER(info) &&
> |
> | OK, if we can trust SI_FROMUSER(), then it is better, i agree.
> |
> | I was worried about in-kernel usage of .si_code <= 0 ...
> |
> | > +				info->si_code != SI_ASYNCIO)
> |
> | but this is horrible, imho.
>
> I am beginning to accept that some amount of ugliness is inevitable
> here :-)

heh, agreed...

> I tried to dig through history of SI_ASYNCIO, but did not
> find any changes to its definition in siginfo.h in 6 years.

basically, it was needed (afaics) because we didn't have "struct pid"
when the patch was sent. Commit 46113830a18847cff8da73005e57bc49c2f95a56

(but the fact that SI_FROMUSER(SI_ASYNCIO) == T is imho unforgivable ;)

> | OK, if we can't change the ABI, then perhaps we can change
> | kill_pid_info_as_uid() to not send the fatal signals to UNKILLABLE
> | task? This helper is strange and ugly anyway,
> |
> |
> | To clarify, I do not blame the patch itself, and I do not suggest
> | to do this right now.
>
> By 'to do this' I assume you are referring to the kill_pid_info_as_uid()
> change above ?
>
> IOW, ugly as it is, can we go with the siginfo_from_user() as in the patch ?

Yes. Sorry if I was not clear. I think that this part of patch is imho
horrible, but we should blame drivers/usb/core/devio.c. I'd personally
like to move the uglification to kill_pid_info_as_uid(), but we can do
this later.

Oleg.

