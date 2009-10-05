Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZJEUrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZJEUrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZJEUrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:47:45 -0400
Received: from mail-ew0-f213.google.com ([209.85.219.213]:47324 "EHLO
	mail-ew0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZJEUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PGuWCAnO8W4cFfZ9JuUNt1ongaCnTBTS0Qoh3ji3Jck7eYftycPXF9O9KCaRGMv3CF
         BKPCUO4Q2x3di++tjHIQb9pxhmYTV8ENrrcPUYQWQE/3ElST2t58e0JtbIddqGbrPRTk
         hjeH+/jAfKPMsb6bWoh5MpcvRkRIVeczS8Lps=
Date: Mon, 5 Oct 2009 22:47:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] perf build questions
Message-ID: <20091005204704.GD6071@nowhere>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005131729.78444bfb.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 01:17:29PM -0700, Randy Dunlap wrote:
> Hi,
> 
> How do I build 'perf' for an i386 target when running on x86_64?
> and how do I do 'perf' cross-builds in general?
> 


I let someone else who knows that better than me answer to that.
But you may need to override the CC var in the makefile for now.
This is something we should make tunable.

 
> Also, I see build errors/warnings (-Werror).  Others aren't seeing these?
> Just due to my gcc version?
> 
> Patch below.
> 
> Thanks.


Oh thanks. I've never seen them.

The builtin-sched.c warning is right.
But the util/trace-event-parse.c warnings are wrong since the parameters
passed to these functions are always cast to char *

But that is wrong too, these functions should take const char * and
not char * as they never need to touch these strings.

So your patch is correct, I'll just convert the callsites. It's
my bad, I've put these casts to shutdown such warnings while integrating
the trace-cmd lib. I was distracted by harder integration problems.

Thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix perf build warnings/errors in function argument types:
> 
> builtin-sched.c:1894: warning: passing argument 1 of 'sort_dimension__add' discards qualifiers from pointer target type
> util/trace-event-parse.c:685: warning: passing argument 2 of 'read_expected' discards qualifiers from pointer target type
> util/trace-event-parse.c:741: warning: passing argument 4 of 'test_type_token' discards qualifiers from pointer target type
> util/trace-event-parse.c:706: warning: passing argument 2 of 'read_expected_item' discards qualifiers from pointer target type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  tools/perf/builtin-sched.c          |    2 +-
>  tools/perf/util/trace-event-parse.c |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -1287,7 +1287,7 @@ static struct sort_dimension *available_
>  
>  static LIST_HEAD(sort_list);
>  
> -static int sort_dimension__add(char *tok, struct list_head *list)
> +static int sort_dimension__add(const char *tok, struct list_head *list)
>  {
>  	int i;
>  
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -618,7 +618,7 @@ static int test_type(enum event_type typ
>  }
>  
>  static int test_type_token(enum event_type type, char *token,
> -		    enum event_type expect, char *expect_tok)
> +		    enum event_type expect, const char *expect_tok)
>  {
>  	if (type != expect) {
>  		die("Error: expected type %d but read %d",
> @@ -650,7 +650,7 @@ static int read_expect_type(enum event_t
>  	return __read_expect_type(expect, tok, 1);
>  }
>  
> -static int __read_expected(enum event_type expect, char *str, int newline_ok)
> +static int __read_expected(enum event_type expect, const char *str, int newline_ok)
>  {
>  	enum event_type type;
>  	char *token;
> @@ -668,12 +668,12 @@ static int __read_expected(enum event_ty
>  	return 0;
>  }
>  
> -static int read_expected(enum event_type expect, char *str)
> +static int read_expected(enum event_type expect, const char *str)
>  {
>  	return __read_expected(expect, str, 1);
>  }
>  
> -static int read_expected_item(enum event_type expect, char *str)
> +static int read_expected_item(enum event_type expect, const char *str)
>  {
>  	return __read_expected(expect, str, 0);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

