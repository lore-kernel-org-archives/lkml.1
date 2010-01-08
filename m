Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600Ab0AHBFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0AHBFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557Ab0AHBFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:05:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:29776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0AHBFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:05:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=wGvBPwCIgz35r/NlP1FHZrnmsXyOvw/pt7hgsA9hUGm8EBKj03EJvFaVcUHfBYlm7
	DwZxbFEqZyvQHeOL4ipiA==
MIME-Version: 1.0
In-Reply-To: <4B46828C.5000703@cn.fujitsu.com>
References: <cover.1262186097.git.kirill@shutemov.name>
	 <9411cbdd545e1232c916bfef03a60cf95510016d.1262186098.git.kirill@shutemov.name>
	 <6599ad831001061701x72098dacn7a5d916418396e33@mail.gmail.com>
	 <cc557aab1001070436w446ef85n55dd2af5e733f55e@mail.gmail.com>
	 <4B46828C.5000703@cn.fujitsu.com>
Date: Thu, 7 Jan 2010 17:05:37 -0800
Message-ID: <6599ad831001071705k3954642eo3e04cef7a31e3727@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] cgroup: implement eventfd-based generic API for 
	notifications
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 4:55 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Use multi labels is much better:

I disagree with that - in the absence of a language that can do proper
destructor-based cleanup (i.e. a strictly controlled subset of C++ :-)
) I think it's clearer to have a single failure path where you can
clean up anything that needs to be cleaned up, without excessive
dependencies on exactly when the failure occurred. Changes then become
less error-prone.

Paul

>
> label4::
>        fput(cfile);
> label3:
>        eventfd_ctx_put(event->eventfd);
> label2:
>        fput(efile);
> label1:
>        kfree(event);
>
> compared to:
>
> +fail:
> +       if (!IS_ERR(cfile))
> +               fput(cfile);
> +
> +       if (event && event->eventfd && !IS_ERR(event->eventfd))
> +               eventfd_ctx_put(event->eventfd);
> +
> +       if (!IS_ERR(efile))
> +               fput(efile);
> +
> +       kfree(event);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
