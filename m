Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbZE3NoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbZE3NoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932190AbZE3NoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:44:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35030 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbZE3NoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:44:09 -0400
Date: Sat, 30 May 2009 09:44:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Subject: Re: [RFC V2 PATCH]debugfs:Fix terminology inconsistency of dir name
  to mount debugfs filesystem.
In-Reply-To: <49b7c2350905300421q7c1c9110ke99e25eec051f94c@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905300939450.14994@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>  <1243613134.20635.14.camel@centos51>  <alpine.DEB.2.00.0905291240150.31247@gandalf.stny.rr.com>  <49b7c2350905291843i402b7161xf05fdb87eb77f73f@mail.gmail.com>  <alpine.DEB.2.00.0905292204280.14994@gandalf.stny.rr.com>
  <49b7c2350905300238k5f6259fne30ad94f8fbf7e20@mail.gmail.com> <49b7c2350905300421q7c1c9110ke99e25eec051f94c@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 30 May 2009, GeunSik Lim wrote:
> @@ -1202,11 +1208,57 @@ something like this simple program:
> 
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <string.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
>  #include <unistd.h>
> 
> +#define _STR(x) #x
> +#define STR(x) _STR(x)
> +#define MAX_PATH 256
> +
> +const char *find_debugfs(char *file_name)
> +{
> +       static char debugfs[MAX_PATH+1];
> +       static int debugfs_found;
> +       char type[100];
> +       FILE *fp;
> +       int size;
> +
> +       if (debugfs_found)
> +               return debugfs;
> +
> +       if ((fp = fopen("/proc/mounts","r")) == NULL) {
> +               perror("/proc/mounts");
> +               return NULL;
> +       }
> +
> +       while (fscanf(fp, "%*s %"
> +                     STR(MAX_PATH)
> +                     "s %99s %*s %*d %*d\n",
> +                     debugfs, type) == 2) {
> +               if (strcmp(type, "debugfs") == 0)
> +                       break;
> +       }
> +       fclose(fp);
> +
> +       if (strcmp(type, "debugfs") != 0) {
> +               fprintf(stderr, "debugfs not mounted");
> +               return NULL;
> +       }
> +
> +       debugfs_found = 1;
> +
> +       size = MAX_PATH - strlen(debugfs);
> +       strncat(debugfs, "/tracing/", size);
> +
> +       size = MAX_PATH - strlen(debugfs);
> +       strncat(debugfs, file_name, size);

You need to make two functions. One to find the debugfs and one to add the 
file. The "debugfs_found" will make the function return just the first 
file_name every time. Something like this: (remove the file_name from 
find_debugfs).

const char *tracing_file(const char *file_name)
{
	static char trace_file[MAX_PATH+1];

	snprintf(trace_file, MAX_PATH, "%s/%s", find_debugfs(), file_name);

	return trace_file;
}

The above is not thread safe, but is OK for non threaded programs.

-- Steve

> +
> +       return debugfs;
> +}
> +
>  int main (int argc, char **argv)
>  {
>          if (argc < 1)
> @@ -1217,12 +1269,12 @@ int main (int argc, char **argv)
>                  char line[64];
>                  int s;
> 
> -                ffd = open("/debug/tracing/current_tracer", O_WRONLY);
> +                ffd = open(find_debugfs("current_tracer"), O_WRONLY);
>                  if (ffd < 0)
>                          exit(-1);
>                  write(ffd, "nop", 3);
> 
> -                fd = open("/debug/tracing/set_ftrace_pid", O_WRONLY);
> +                fd = open(find_debugfs("set_ftrace_pid"), O_WRONLY);
>                  s = sprintf(line, "%d\n", getpid());
>                  write(fd, line, s);
> 
