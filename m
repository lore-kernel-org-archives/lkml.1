Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZJBWx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZJBWx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZJBWx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:53:26 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:58739 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZJBWxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=G0NSWm6OtlzxGLF4wbJG3Rqqs8pC21CPPKghGniobK3wrfnRjQYmY+Dmk5/EENApEs
         ZglX2dKRxlTfmvWMeMIR58zbBzRMHe+7xO1j0DLgaivMPCDd2BcBR8sVSrH5qrZvEhcD
         mEih+GN/vssFEHZcXhcuGXLEV8XEo7xrYchXQ=
MIME-Version: 1.0
In-Reply-To: <1254519449.4605.33.camel@timo-desktop>
References: <1254519449.4605.33.camel@timo-desktop>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 2 Oct 2009 18:53:08 -0400
Message-ID: <3e8340490910021553ua53ab26gdb3f96af80cec768@mail.gmail.com>
Subject: Re: setproctitle()
To: Timo Sirainen <tss@iki.fi>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 5:37 PM, Timo Sirainen <tss@iki.fi> wrote:
> I'd like to get BSD's setproctitle() implemented for glibc so that more
> programs could start using it. The current method of messing around with
> argv and environment to implement it is horribly ugly, fragile and I
> find it dangerous enough that I haven't dared to use it in my programs.
>
> Any chance of making all this easier so it could actually be implemented
> in a generic and safe way in glibc?
>
> I guess there are several different ways it could be done. My first idea
> was to have some magic value in beginning of cmdline (\0 followed by a
> few characters) followed by a pointer to the actual string. But that's a
> bit ugly and userspace can't easily figure out if this is supported by
> kernel.
>
> So the second idea, perhaps this will work? Reserve space for the
> pointer between arg_end and env_start. If it's NULL, use the old way. If
> it's non-NULL, use it for the cmdline. Userspace can check if this is
> supported by seeing if environ[0] - (argv[argc-1] + strlen(argv[argc-1])
> + 1) == sizeof(void *).
>

This won't work - the start of the env variables is _defined_ by the
end of the argument vector, as found on the initial stack when the
program is loaded - see the initial stack diagram at [1].

Interestingly, there is some code that purports to handle
setproctitle(): (fs/proc/base.c)
    res = access_process_vm(task, mm->arg_start, buffer, len, 0);

    // If the nul at the end of args has been overwritten, then
    // assume application is using setproctitle(3).
    if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
        len = strnlen(buffer, res);
        if (len < res) {
            res = len;
        } else {
            len = mm->env_end - mm->env_start;
            if (len > PAGE_SIZE - res)
                len = PAGE_SIZE - res;
            res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
            res = strnlen(buffer, res);
        }
    }

This would seem to allow the argument space to be extended up until
the end of the environment variable area (although it seems to have a
bug where it will ignore errors when reading this extra bit!)

Nevertheless, if one were to insist on a more controllable method, a
better way might be to simply define a syscall that userspace can use
to select a new command line buffer. Overwrite mm->arg_end and
mm->arg_start, and there you go. Of course, the logic over here needs
to be disabled in this case, as env variables will no longer be found
immediately after the argument vector.

[1] - http://manugarg.googlepages.com/aboutelfauxiliaryvectors
