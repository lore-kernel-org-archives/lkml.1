Return-Path: <linux-kernel-owner+w=401wt.eu-S932562Ab0AGBdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab0AGBdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009Ab0AGBdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:33:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0AGBdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:33:17 -0500
Subject: Re: [PATCH] ring_buffer: wrap a list.next reference with
 rb_list_head()
From: Steven Rostedt <srostedt@redhat.com>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, jiayingz@google.com,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1262826727-9090-1-git-send-email-dhsharp@google.com>
References: <1262826727-9090-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 06 Jan 2010 20:33:10 -0500
Message-Id: <1262827990.2737.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a FYI, it's best to send me email to my rostedt@goodmis.org
account. I don't always read my messages on my redhat account.

On Wed, 2010-01-06 at 17:12 -0800, David Sharp wrote:
> This reference at the end of rb_get_reader_page() was causing off-by-one
> writes to the prev pointer of the page after the reader page when that
> page is the head page, and therefore the reader page has the RB_PAGE_HEAD
> flag in its list.next pointer. This eventually results in a GPF in a
> subsequent call to rb_set_head_page() (usually from rb_get_reader_page())
> when that prev pointer is dereferenced. The dereferenced register would
> characteristically have an address that appears shifted left by one byte
> (eg, ffxxxxxxxxxxxxyy instead of ffffxxxxxxxxxxxx) due to being written at
> an address one byte too high.
> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  kernel/trace/ring_buffer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 2326b04..d5b7308 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2906,7 +2906,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	 *
>  	 * Now make the new head point back to the reader page.
>  	 */
> -	reader->list.next->prev = &cpu_buffer->reader_page->list;
> +	rb_list_head(reader->list.next)->prev = &cpu_buffer->reader_page->list;
>  	rb_inc_page(cpu_buffer, &cpu_buffer->head_page);

Wow, this is a nasty little race. The writer had to move the header page
forward by one between the time we swapped to now, which is the command
just outside the diff.

>  
>  	/* Finally update the reader page to the new head */

We probably should add a change at the top too, just to be safe.

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2326b04..edefe3b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2869,7 +2869,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
-	cpu_buffer->reader_page->list.next = reader->list.next;
+	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
 	/*


Thanks, I'll apply this.

-- Steve


