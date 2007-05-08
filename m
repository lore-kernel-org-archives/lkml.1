Return-Path: <linux-kernel-owner+w=401wt.eu-S1032388AbXEHV7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032388AbXEHV7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968375AbXEHV7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:59:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51664 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968266AbXEHV7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:59:14 -0400
Date: Tue, 8 May 2007 15:01:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Howells <dhowells@redhat.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Subject: Re: [patch 3/4] split usermodehelper setup from execution
Message-Id: <20070508150156.402980c6.randy.dunlap@oracle.com>
In-Reply-To: <20070508205517.256147592@goop.org>
References: <20070508205129.064843364@goop.org>
	<20070508205517.256147592@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 13:51:32 -0700 Jeremy Fitzhardinge wrote:

> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -253,11 +262,94 @@ static void __call_usermodehelper(struct
>  }
>  
>  /**
> - * call_usermodehelper_keys - start a usermode application
> - * @path: pathname for the application
> - * @argv: null-terminated argument list
> - * @envp: null-terminated environment list
> - * @session_keyring: session keyring for process (NULL for an empty keyring)
> + * call_usermodehelper_setup - prepare to call a usermode helper
> + * @path - path to usermode executable
> + * @argv - arg vector for process
> + * @envp - environment for process

s / - /: / above please.

> + *
> + * Returns either NULL on allocation failure, or a subprocess_info
> + * structure.  This should be passed to call_usermodehelper_exec to
> + * exec the process and free the structure.
> + */
> +struct subprocess_info *call_usermodehelper_setup(char *path,
> +						  char **argv, char **envp)
> +{
> +}
> +EXPORT_SYMBOL(call_usermodehelper_setup);
> +
> +/**
> + * call_usermodehelper_setkeys - set the session keys for usermode helper
> + * @info - a subprocess_info returned by call_usermodehelper_setup
> + * @session_keyring - the session keyring for the process

and here.

> + */
> +
> +/**
> + * call_usermodehelper_setcleanup - set a cleanup function
> + * @info  - a subprocess_info returned by call_usermodehelper_setup
> + * @cleanup - a cleanup function

again.

> + *
> + * The cleanup function is just befor ethe subprocess_info is about to
> + * be freed.  This can be used for freeing the argv and envp.  The
> + * Function must be runnable in either a process context or the
> + * context in which call_usermodehelper_exec is called.
> + */
> +void call_usermodehelper_setcleanup(struct subprocess_info *info,
> +				    void (*cleanup)(char **argv, char **envp))
> +{
> +	info->cleanup = cleanup;
> +}
> +EXPORT_SYMBOL(call_usermodehelper_setcleanup);
> +
> +/**
> + * call_usermodehelper_stdinpipe - set up a pipe to be used for stdin
> + * @sub_info - a subprocess_info returned by call_usermodehelper_setup
> + * @filp - set to the write-end of a pipe

again.

> + *
> + * This constructs a pipe, and sets the read end to be the stdin of the
> + * subprocess, and returns the write-end in *@filp.
> + */
> +int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
> +				  struct file **filp)
> +{
> +}
> +EXPORT_SYMBOL(call_usermodehelper_stdinpipe);

...

> +/**
> + * call_usermodehelper_pipe - call a usermode helper process with a pipe stdin
> + * @path - path to usermode executable
> + * @argv - arg vector for process
> + * @envp - environment for process
> + * @filp - set to the write-end of a pipe

and here.

> + *
> + * This is a simple wrapper which executes a usermode-helper function
> + * with a pipe as stdin.  It is implemented entirely in terms of
> + * lower-level call_usermodehelper_* functions.
> + */
>  int call_usermodehelper_pipe(char *path, char **argv, char **envp,
>  			     struct file **filp)
>  {


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
