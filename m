Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYELQAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYELQAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYELQAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:00:05 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4998 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYELQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:00:04 -0400
Subject: Re: [RFC/PATCH] printk: detect incomplete lines
From: Joe Perches <joe@perches.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Rob Landley <rob@landley.net>
In-Reply-To: <20080512114925.GA29407@damson.getinternet.no>
References: <20080512114925.GA29407@damson.getinternet.no>
Content-Type: text/plain
Date: Mon, 12 May 2008 08:35:04 -0700
Message-Id: <1210606504.5880.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-12 at 13:49 +0200, Vegard Nossum wrote:
> So we are now using __builtin_frame_address(). This should work everywhere
> and should not cause any harmful side effects.

Perhaps print an identifier using __builtin_frame_address(0)
to allow an external tool to reassemble complete messages?

> +	if (prev_caller != __builtin_frame_address(0) && !log_level_unknown) {
> +		emit_log_char('.');
> +		emit_log_char('.');
> +		emit_log_char('.');
> +		emit_log_char('\n');
> +		log_level_unknown = 1;
> +	}
> +
> +	prev_caller = __builtin_frame_address(0);
> +

maybe something like:

static void emit_log_id(void *addr)
{
	unsigned int i = 0;
	char id[sizeof(void *) * 2 + 6];
	sprintf(id, "{@%p}", addr);
	while (*id[i])
		emit_log_char(id[i++]);
}
...
	caller = __builtin_frame_address(0);
	if (prev_caller != caller && !log_level_unknown) {
		emit_log_id(caller);
		log_level_unknown = 1;
		prev_caller = caller;
	}


