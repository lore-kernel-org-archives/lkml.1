Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbYCYOiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbYCYOiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYCYOiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:38:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:45520 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753513AbYCYOiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:38:02 -0400
Subject: Re: [PATCH] Discard notification signals when a tracer exits
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1206455513.17227.4.camel@elijah.suse.cz>
References: <1206455513.17227.4.camel@elijah.suse.cz>
Content-Type: multipart/mixed; boundary="=-CQ1IhZwYJJ5hcRLF7Ul+"
Organization: SuSE CR
Date: Tue, 25 Mar 2008 15:37:58 +0100
Message-Id: <1206455878.17227.11.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CQ1IhZwYJJ5hcRLF7Ul+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-03-25 at 15:31 +0100, Petr Tesarik wrote:
> When a tracer exits without detaching from the traced process, the
> tracee may be at a tracer notification stop and will thus interpret
> the value in task->exit_code (SIGTRAP | 0x80) as the signal to be
> delivered.
> 
> This patch fixes the problem by clearing exit_code when detaching
> the traced process from a dying tracer.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> 

Oh, and here is a testing script for the first hunk. It fails on all
kernels I have tried. The second hunk can also be tested if you run
strace on the traced process instead of attaching to a running one, but
I didn't figure out how to get the PID of the traced process within a
script, so you'd have to trigger the bug manually.

> ---
>  exit.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -642,8 +642,10 @@ reparent_thread(struct task_struct *p, s
>  			/*
>  			 * If it was at a trace stop, turn it into
>  			 * a normal stop since it's no longer being
> -			 * traced.
> +			 * traced.  Cancel the notification signal,
> +			 * or the tracee may get a SIGTRAP.
>  			 */
> +			p->exit_code = 0;
>  			ptrace_untrace(p);
>  		}
>  	}
> @@ -713,6 +715,10 @@ static void forget_original_parent(struc
>  			p->real_parent = reaper;
>  			reparent_thread(p, father, 0);
>  		} else {
> +			/* cancel the notification signal at a trace stop */
> +			if (p->state == TASK_TRACED)
> +				p->exit_code = 0;
> +
>  			/* reparent ptraced task to its real parent */
>  			__ptrace_unlink (p);
>  			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=-CQ1IhZwYJJ5hcRLF7Ul+
Content-Disposition: attachment; filename=test-trap.sh
Content-Type: application/x-shellscript; name=test-trap.sh
Content-Transfer-Encoding: base64

IyEvYmluL3NoCgpUUklFUz0xMAoKZm9yICgoYSA9IDEgOyBhIDw9ICRUUklFUyA7IGErKykpCmRv
CiAgICBjYXQgL2Rldi96ZXJvID4vZGV2L251bGwgJgogICAgQ0FUX1BJRD0kIQoKICAgIGVjaG8g
InRyYWNlZSBzdGFydGVkIHdpdGggUElEICRDQVRfUElEIgoKICAgIHN0cmFjZSAtcCAkQ0FUX1BJ
RCAyPi9kZXYvbnVsbCAmCiAgICBTVFJBQ0VfUElEPSQhCgogICAgZWNobyAidHJhY2VyIHN0YXJ0
ZWQgd2l0aCBQSUQgJFNUUkFDRV9QSUQiCgogICAgc2xlZXAgMC4xCiAgICBraWxsIC05ICRTVFJB
Q0VfUElECiAgICB3YWl0ICRTVFJBQ0VfUElECgogICAgRkFJTEVEPTAKICAgIGlmICEga2lsbCAt
OSAkQ0FUX1BJRAogICAgdGhlbgogICAgICAgIGVjaG8gIioqKiBFUlJPUiAqKiogVHJhY2VlIGRp
c2FwcGVhcmVkIG15c3RlcmlvdXNseSIKCUZBSUxFRD0xCiAgICBmaQoKICAgIHdhaXQgJENBVF9Q
SUQKICAgIENBVF9TVEFUVVM9JD8KICAgIGlmIFsgIiRDQVRfU1RBVFVTIiAtbmUgMTM3IF0JIyAx
MjggKyA5IG1lYW5zIGtpbGxlZCB3aXRoIFNJR0tJTEwKICAgIHRoZW4KCWVjaG8gIioqKiBXQVJO
SU5HICoqKiBUcmFjZWUgZXhpdGVkIHdpdGggc3RhdHVzICRDQVRfU1RBVFVTIgogICAgZmkKICAg
IGlmIFsgIiRGQUlMRUQiIC1uZSAwIF0KICAgIHRoZW4KCWV4aXQgJEZBSUxFRAogICAgZmkKZG9u
ZQoKZWNobyAiVGhlIGJ1ZyB3YXMgbm90IHJlcHJvZHVjZWQgYWZ0ZXIgJFRSSUVTIHRyaWVzIgpl
eGl0IDAK


--=-CQ1IhZwYJJ5hcRLF7Ul+--
