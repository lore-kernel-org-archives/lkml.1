Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZFAQCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZFAQCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZFAQCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:02:13 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:27966 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZFAQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:02:12 -0400
Message-ID: <4A23FC2C.4060602@oracle.com>
Date: Mon, 01 Jun 2009 09:05:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts: allow docproc invocation from external
References: <1243785934-13936-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1243785934-13936-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A23FB75.0060:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> - getcwd returns path without a slash at the end, add the slash

Hi Jiri,

This part (above) fixes a bug, right?

> - add KBUILD_SRC env support, so that we can specify path for
>   kernel (to know where scripts/kernel-doc resides) and SRCTREE
>   (for searching files referenced in .tmpl) separately

Can you explain your usage a bit more so that I can understand some
justification for this change?  (not that I'm objecting to it)


> [v2]
> - use KBUILD_SRC instead of a newly introduced environment variable
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  scripts/basic/docproc.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
> index 35bdc68..4c9523e 100644
> --- a/scripts/basic/docproc.c
> +++ b/scripts/basic/docproc.c
> @@ -69,7 +69,7 @@ FILELINE * docsection;
>  #define NOFUNCTION    "-nofunction"
>  #define NODOCSECTIONS "-no-doc-sections"
>  
> -char *srctree;
> +static char *srctree, *kernsrctree;
>  
>  void usage (void)
>  {
> @@ -77,7 +77,8 @@ void usage (void)
>  	fprintf(stderr, "Input is read from file.tmpl. Output is sent to stdout\n");
>  	fprintf(stderr, "doc: frontend when generating kernel documentation\n");
>  	fprintf(stderr, "depend: generate list of files referenced within file\n");
> -	fprintf(stderr, "Environment variable SRCTREE: absolute path to kernel source tree.\n");
> +	fprintf(stderr, "Environment variable SRCTREE: absolute path to sources.\n");

What "sources" other than the kernel source tree is SRCTREE used for?

> +	fprintf(stderr, "                     KBUILD_SRC: absolute path to kernel source tree.\n");
>  }
>  
>  /*
> @@ -96,8 +97,8 @@ void exec_kernel_doc(char **svec)
>  			exit(1);
>  		case  0:
>  			memset(real_filename, 0, sizeof(real_filename));
> -			strncat(real_filename, srctree, PATH_MAX);
> -			strncat(real_filename, KERNELDOCPATH KERNELDOC,
> +			strncat(real_filename, kernsrctree, PATH_MAX);
> +			strncat(real_filename, "/" KERNELDOCPATH KERNELDOC,
>  					PATH_MAX - strlen(real_filename));
>  			execvp(real_filename, svec);
>  			fprintf(stderr, "exec ");
> @@ -178,6 +179,7 @@ void find_export_symbols(char * filename)
>  		char real_filename[PATH_MAX + 1];
>  		memset(real_filename, 0, sizeof(real_filename));
>  		strncat(real_filename, srctree, PATH_MAX);
> +		strncat(real_filename, "/", PATH_MAX - strlen(real_filename));
>  		strncat(real_filename, filename,
>  				PATH_MAX - strlen(real_filename));
>  		sym = add_new_file(filename);
> @@ -382,6 +384,9 @@ int main(int argc, char *argv[])
>  	srctree = getenv("SRCTREE");
>  	if (!srctree)
>  		srctree = getcwd(NULL, 0);
> +	kernsrctree = getenv("KBUILD_SRC");
> +	if (!kernsrctree)
> +		kernsrctree = srctree;
>  	if (argc != 3) {
>  		usage();
>  		exit(1);


Thanks.
-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
