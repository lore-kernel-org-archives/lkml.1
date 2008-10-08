Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYJHEFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYJHEFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 00:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYJHEFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 00:05:10 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:40968 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbYJHEFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 00:05:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AowFAOfI60hMQWq+/2dsb2JhbACBcrxWgWo
Date: Wed, 8 Oct 2008 00:05:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: fix unchecked format
Message-ID: <20081008040508.GB31788@Krystal>
References: <48EC19A8.4010307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48EC19A8.4010307@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:58:12 up 125 days,  8:38,  9 users,  load average: 1.02, 0.48,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> 
> when the second, third... probe is registered, its format is
> not checked, this patch fix it.
> 

It's already checked here :

marker_update_probes
  marker_update_probe_range
    set_marker
 
        if ((*entry)->format) {
                if (strcmp((*entry)->format, elem->format) != 0) {
                        printk(KERN_NOTICE
                                "Format mismatch for probe %s "
                                "(%s), marker (%s)\n",
                                (*entry)->name,
                                (*entry)->format,
                                elem->format);
                        return -EPERM;
                }
        } else {
                ret = marker_set_format(entry, elem->format);
                if (ret)
                        return ret;
        }

Given that marker_probe_register can be called to connect a probe to a
marker which does not exist yet (e.g. marker in a module not loaded), I
am not sure it makes sense to check for format string mismatch so early
in marker_probe_register (the moment it adds the marker to the hash
table). That's actually why I chose to leave it in later stage which
does the actual connection of the probes to the markers
(marker_update_probes).

If you really want to check it earlier, how do you plan to deal with
this scenario ?

1 - a marker probe is registered for markerA with format string
    "field1 %s"
2 - a module is loaded, which contains a marker markerA with format
    string "field1 %d"

I think it would be _really_ bad to make the module load fail because of
a marker format string mismatch... this is why I chose just to give a
warning in set_marker, which is shown when the markers are updated,
which happens when the module is loaded and when the marker hash table
is modified.

Mathieu

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 4440a09..1196a6b 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -651,11 +651,17 @@ int marker_probe_register(const char *name, const char *format,
>  	entry = get_marker(name);
>  	if (!entry) {
>  		entry = add_marker(name, format);
> -		if (IS_ERR(entry)) {
> +		if (IS_ERR(entry))
>  			ret = PTR_ERR(entry);
> -			goto end;
> -		}
> +	} else if (format) {
> +		if (!entry->format)
> +			ret = marker_set_format(&entry, format);
> +		else if (strcmp(entry->format, format))
> +			ret = -EPERM;
>  	}
> +	if (ret)
> +		goto end;
> +
>  	/*
>  	 * If we detect that a call_rcu is pending for this marker,
>  	 * make sure it's executed now.
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
