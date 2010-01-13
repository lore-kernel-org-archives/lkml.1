Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850Ab0AMNkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0AMNkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182Ab0AMNkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:40:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:36231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab0AMNkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:40:05 -0500
Date: Wed, 13 Jan 2010 11:39:52 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/6] perf top: teach it to autolocate vmlinux
Message-ID: <20100113133952.GD2934@ghostprotocols.net>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
 <de6bae3b8d61ea3db1a797f31ebea6e3ed8c00a8.1262952612.git.kirr@landau.phys.spbu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de6bae3b8d61ea3db1a797f31ebea6e3ed8c00a8.1262952612.git.kirr@landau.phys.spbu.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 08, 2010 at 03:23:04PM +0300, Kirill Smelkov escreveu:
> By relying on logic in dso__load_kernel_sym(), we can automatically load
> vmlinux.
> 
> The only thing which needs to be adjusted, is how --sym-annotate option
> is handled - now we can't rely on vmlinux been loaded until full
> successful pass of dso__load_vmlinux(), but that's not the case if we'll
> do sym_filter_entry setup in symbol_filter().
> 
> So move this step right after event__process_sample() where we know the
> whole dso__load_kernel_sym() pass is done.
> 
> By the way, though conceptually similar `perf top` still can't annotate
> userspace - see next patches with fixes.
> 
> Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
> Cc: Mike Galbraith <efault@gmx.de>
> ---

<SNIP>

> @@ -951,6 +953,13 @@ static void event__process_sample(const event_t *self,
>  	    al.sym == NULL || al.filtered)
>  		return;
>  
> +	/* let's see, whether we need to install initial sym_filter_entry */
> +	if (sym_filter_entry_sched) {
> +		sym_filter_entry = sym_filter_entry_sched;
> +		sym_filter_entry_sched = NULL;
> +		parse_source(sym_filter_entry);
> +	}
> +

You're assuming that the first sample is for the kernel, right? It may
be not and then the vmlinux won't be loaded at this point.

I think that the right way is to force it to be loaded by calling:

	map__load(session->vmlinux_maps[MAP__FUNCTION], session, filter);

after perf_session__create_kernel_maps and before parse_source(), ok?

	You can even create a helper:

int perf_session__load_vmlinux(struct perf_session *self,
                               symbol_filter_t filter)
{
	return map__load(session->vmlinux_maps[MAP__FUNCTION],
			 session, filter);
}

	As this probably will be of interest for tools such as 'perf
probe', etc.

- Arnaldo
