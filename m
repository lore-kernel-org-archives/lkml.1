Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbZAGTyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbZAGTyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZAGTyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:54:07 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33776 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZAGTyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:54:06 -0500
Date: Wed, 7 Jan 2009 20:55:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/1] scripts: allow docproc invocation from external
Message-ID: <20090107195542.GD4647@uranus.ravnborg.org>
References: <1231164510-14355-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231164510-14355-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 03:08:30PM +0100, Jiri Slaby wrote:
> - getcwd returns path without slash at the end, add the slash
> - add KERNSRCTREE env, so that we can specify path for kernel
>   (for knowing where to find scripts/kernel-doc) and SRCTREE
>   (for searching files referenced in .tmpl) separately


Kbuild already have:

KBUILD_SRC that point to the source tree
KBUILD_OUTPUT that points to the output directory

Could we reuse these?

	Sam

> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  scripts/basic/docproc.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
> index 35bdc68..c716ae8 100644
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
> +	fprintf(stderr, "                     KERNSRCTREE: absolute path to kernel source tree.\n");
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
> +	kernsrctree = getenv("KERNSRCTREE");
> +	if (!kernsrctree)
> +		kernsrctree = srctree;
>  	if (argc != 3) {
>  		usage();
>  		exit(1);
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
