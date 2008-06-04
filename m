Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYFDJAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYFDJAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbYFDI7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:59:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbYFDI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:59:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=N6J1WnBVIC3NtTqswuufV0I4tH9cGRXRChM25B1tRJTVdqdL9J5Ih6S429gIcHGlI
	68vruSymPSyfXIMKH4i/Q==
Message-ID: <6599ad830806040159i4dfd8350w54e41c5ba4e0c8c4@mail.gmail.com>
Date: Wed, 4 Jun 2008 01:59:31 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
In-Reply-To: <20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 10:01 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>        int ret;
>        char *buf, *end;
> @@ -133,13 +145,101 @@ ssize_t res_counter_write(struct res_cou
>                if (*end != '\0')
>                        goto out_free;
>        }
> -       spin_lock_irqsave(&counter->lock, flags);
> -       val = res_counter_member(counter, member);
> -       *val = tmp;
> -       spin_unlock_irqrestore(&counter->lock, flags);
> -       ret = nbytes;
> +       if (set_strategy) {
> +               ret = set_strategy(res, tmp, member);
> +               if (!ret)
> +                       ret = nbytes;
> +       } else {
> +               spin_lock_irqsave(&counter->lock, flags);
> +               val = res_counter_member(counter, member);
> +               *val = tmp;
> +               spin_unlock_irqrestore(&counter->lock, flags);
> +               ret = nbytes;
> +       }

I think that the hierarchy/reclaim handling that you currently have in
the memory controller should be here; the memory controller should
just be able to pass a reference to try_to_free_mem_cgroup_pages() and
have everything else handled by res_counter.

Paul
