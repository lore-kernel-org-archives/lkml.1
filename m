Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYIJDMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYIJDMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYIJDLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:11:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28393 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751779AbYIJDLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:11:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-scanned-by;
	b=hplKrAPa64+0vDMN9okOdxuea5nutGqMPF99KhydIZQnd8DwzDw2aApa9FLU5pemN
	7NrNQhA09ioBAOCRlMcPw==
Message-ID: <6599ad830809092011x6fce5a70kcd4fb77bf37c46a2@mail.gmail.com>
Date: Tue, 9 Sep 2008 20:11:39 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>
In-Reply-To: <48C72E7C.8080302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AA684B.7000704@cn.fujitsu.com>
	 <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com>
	 <48C72E7C.8080302@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 7:18 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>        hlist_for_each_entry(cg, node, hhead, hlist) {
>                if (!memcmp(template, cg->subsys, sizeof(cg->subsys))) {
>                        /* All subsystems matched */
> +                       if (!kref_get_not_zero(&cg->ref))
> +                               return NULL;

Maybe it would be better to do:

if (!memcmp(...) && kref_get_not_zero(&cg->ref))
  return cg;

so that in the event of a race, we carry on looking in the array.
> + * Return 0 if this refcount is 0, otherwise return 1.
> + */
> +int kref_get_not_zero(struct kref *kref)

Probably clearer to have a bool return type.

Paul
