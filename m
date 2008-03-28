Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYC1Ffa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYC1Ffa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 01:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYC1FfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 01:35:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYC1FfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 01:35:21 -0400
Message-ID: <47EC838D.9060309@redhat.com>
Date: Fri, 28 Mar 2008 01:35:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Denys Vlasenko <vda.linux@googlemail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Markers - remove extra format argument
References: <20080327132057.449831367@polymtl.ca> <200803280101.30026.vda.linux@googlemail.com> <20080328010223.GA8186@Krystal>
In-Reply-To: <20080328010223.GA8186@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
> Denys Vlasenko <vda.linux@googlemail.com> :
>> In this call:
>>
>>                         (*__mark_##name.call)                           \
>>                                 (&__mark_##name, call_private,          \
>>                                 format, ## args);                       \
>>
>> you make gcc allocate duplicate format string. You can use
>> &__mstrtab_##name[sizeof(#name)] instead since it holds the same string,
>> or drop ", format," above and "const char *fmt" from here:
>>
>>         void (*call)(const struct marker *mdata,        /* Probe wrapper */
>>                 void *call_private, const char *fmt, ...);
>>
>> since mdata->format is the same and all callees which need it can take it there.
> 
> Very good point. I actually thought about dropping it, since it would
> remove an unnecessary argument from the stack. And actually, since I now
> have the marker_probe_cb sitting between the marker site and the
> callbacks, there is no API change required. Thanks :)

First of all, I'm very interested in the marker, and your patches look
useful for me.

By the way, could you tell me what the call_private is for?
In your patch, that is used only from special function below.

> @@ -1844,3 +1848,22 @@ int valid_swaphandles(swp_entry_t entry,
>  	*offset = ++toff;
>  	return nr_pages? ++nr_pages: 0;
>  }
> +
> +void ltt_dump_swap_files(void *call_data)
> +{
> +	int type;
> +	struct swap_info_struct *p = NULL;
> +
> +	mutex_lock(&swapon_mutex);
> +	for (type = swap_list.head; type >= 0; type = swap_info[type].next) {
> +		p = swap_info + type;
> +		if ((p->flags & SWP_ACTIVE) != SWP_ACTIVE)
> +			continue;
> +		__trace_mark(0, statedump_swap_files, call_data,
> +			"filp %p vfsmount %p dname %s",
> +			p->swap_file, p->swap_file->f_vfsmnt,
> +			p->swap_file->f_dentry->d_name.name);
> +	}
> +	mutex_unlock(&swapon_mutex);
> +}
> +EXPORT_SYMBOL_GPL(ltt_dump_swap_files);
> 

However, I think call_data can be passed as an argument.
If so, I think you can also drop it, like this.

 void (*call)(const struct marker *mdata, ...);


Best regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

