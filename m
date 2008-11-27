Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYK0NGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYK0NGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYK0NGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:06:40 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:50766 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYK0NGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MoEKtCE0BfejY4F/QkhpaBWqP3j6Fhf5UR9MSPJNfjfOWKi5zbwNx5O37iDfyuSAST
         1LtM1U0Jv2kxc9hSRZ50aL6kJE+FNRkuiyPgS1lMcRl2EIsC/AUEoWb/szcPr5GllNcg
         XJsFwRBfbXuc7lTlsndna+7HUe8GDp7r1vayw=
Message-ID: <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com>
Date: Thu, 27 Nov 2008 14:06:38 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081127103424.GA9132@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Ingo Molnar <mingo@elte.hu>:
> But in fact, it might be even better to display the costs like this,
> on the left side [mockup]:
>
> ---------------------------------------------------------
> CPU)     cost    |  function
> ---------------------------------------------------------
>
>  0)             |  sys_read() {
>  0)    0.331 us |    fget_light();
>  0)             |    vfs_read() {
>  0)             |      rw_verify_area() {
>  0)             |        security_file_permission() {
>  0)    0.306 us |          cap_file_permission();
>  0)    0.300 us |          cap_file_permission();
>  0)    8.909 us |        }
>  0)    0.993 us |      }
>  0)   11.649 us |    }
>  0)             |    do_sync_read() {
>  0)             |      sock_aio_read() {
>  0)             |        __sock_recvmsg() {
>  0)             |          security_socket_recvmsg() {
>  0)  100.319 us |            cap_socket_recvmsg();
> ---------------------------------------------------------
>
> note the 8 small tweaks i did to optimize the visual real estate of
> the tracer output:
>
> 1) we done need reminders on the left side that this is about CPU
>   numbers. It will be obvious anyway if it's "all mixed up".
>   (microseconds is different - that is a unit that will be quoted and
>    it's also a number that actually matters more in the daily use of
>    such traces )
>
> 2) no need for [] on the left side - a single separator is enough. I
>   picked ')' as it looks pretty natural and unintrusive.
>
> 3) we should use the CPU number width on the left side that
>   log10(cpus_weight_nr(cpu_online_map)) tells us. So if a system has
>   just two cores, we should print single-width. If it has 16 CPUs, we
>   should print 00..01....15.
>
> 4) I left 4 decimal points for the cost. That's up to 9999.999
>   microseconds, after that point we should lose precision and print:
>   99999.99, then should print up to 999999.9, and then print up to
>   99999999 microseconds. Always keep the length of the number at 8
>   characters. Above that, just let the rest shift to the right a bit.
>   (but that will be about delays of more than 100 seconds - that does
>   not really matter in practice)
>
> 5) Note, by printing the cost at fixed width, we can leave out the '+'
>   and '!' visual alerts (sorry! :-). The visible width of the numbers
>   will be enough of an attention grabber - as you can see it in the
>   mockup above already.
>
> 6) Note the vertical '|' separator. I tried it with and without, and i
>   think the code on the right side looks more structured that way. It
>   looks like a sheet of paper, and it looks tidier - so please add
>   it.
>
> 7) Note how unobscured the right side code portion looks like this
>   way. Since this is the only piece of information that is heavily
>   variable-width, we keep it at the end and dont worry about length
>   problems.


Yeah, I will miss a bit the overhead signs, they were really useful to
find in one
quick sight a costly function call.
I know that the decimal. The visible width of the duration replaces it but not
as much efficiently.
Moreover, put these times on the full left will be perhaps harder for
the eyes to retrieve the concerned
function return (thinking of a deep calls).

I don't know, perhaps that will actually be better in practice...

> 8) Please print this in the trace header:
>
>   ---------------------------------------------------------
>   CPU)     cost    |  function
>   ---------------------------------------------------------
>
>   The tabulation format and the field names makes it all more familar
>   and more friendly to people.
>
> What do you think?
>
>        Ingo
>


Ok.
