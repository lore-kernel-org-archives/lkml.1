Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYHRFEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYHRFEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 01:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYHRFEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 01:04:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYHRFEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 01:04:33 -0400
Date: Mon, 18 Aug 2008 01:04:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       miklos@szeredi.hu
Subject: Re: [PATCH 1/2] documentation: split and build smount.c
Message-ID: <20080818050431.GA20692@infradead.org>
References: <20080817214442.ca4345ce.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817214442.ca4345ce.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 09:44:42PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make smount.c source file and add that to Makefile so that its
> build can be checked.

Just remove it, and modern /bin/mount handles shared subtrees just fine

> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Miklos Szeredi <miklos@szeredi.hu>
> ---
>  Documentation/Makefile                      |    2 
>  Documentation/filesystems/00-INDEX          |    2 
>  Documentation/filesystems/Makefile          |    8 ++
>  Documentation/filesystems/sharedsubtree.txt |   82 +---------------------------
>  Documentation/filesystems/smount.c          |   73 ++++++++++++++++++++++++
>  5 files changed, 88 insertions(+), 79 deletions(-)
> 
> --- /dev/null
> +++ lin2627-rc3g4-kerndoc/Documentation/filesystems/smount.c
> @@ -0,0 +1,73 @@
> +//
> +//this code was developed my Miklos Szeredi <miklos@szeredi.hu>
> +//and modified by Ram Pai <linuxram@us.ibm.com>
> +// sample usage:
> +//              smount /tmp shared
> +//
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <sys/mount.h>
> +#include <sys/fsuid.h>
> +
> +#ifndef MS_REC
> +#define MS_REC		0x4000	/* 16384: Recursive loopback */
> +#endif
> +
> +#ifndef MS_SHARED
> +#define MS_SHARED		1<<20	/* Shared */
> +#endif
> +
> +#ifndef MS_PRIVATE
> +#define MS_PRIVATE		1<<18	/* Private */
> +#endif
> +
> +#ifndef MS_SLAVE
> +#define MS_SLAVE		1<<19	/* Slave */
> +#endif
> +
> +#ifndef MS_UNBINDABLE
> +#define MS_UNBINDABLE		1<<17	/* Unbindable */
> +#endif
> +
> +int main(int argc, char *argv[])
> +{
> +	int type;
> +	if(argc != 3) {
> +		fprintf(stderr, "usage: %s dir "
> +		"<rshared|rslave|rprivate|runbindable|shared|slave"
> +		"|private|unbindable>\n" , argv[0]);
> +		return 1;
> +	}
> +
> +	fprintf(stdout, "%s %s %s\n", argv[0], argv[1], argv[2]);
> +
> +	if (strcmp(argv[2],"rshared")==0)
> +		type=(MS_SHARED|MS_REC);
> +	else if (strcmp(argv[2],"rslave")==0)
> +		type=(MS_SLAVE|MS_REC);
> +	else if (strcmp(argv[2],"rprivate")==0)
> +		type=(MS_PRIVATE|MS_REC);
> +	else if (strcmp(argv[2],"runbindable")==0)
> +		type=(MS_UNBINDABLE|MS_REC);
> +	else if (strcmp(argv[2],"shared")==0)
> +		type=MS_SHARED;
> +	else if (strcmp(argv[2],"slave")==0)
> +		type=MS_SLAVE;
> +	else if (strcmp(argv[2],"private")==0)
> +		type=MS_PRIVATE;
> +	else if (strcmp(argv[2],"unbindable")==0)
> +		type=MS_UNBINDABLE;
> +	else {
> +		fprintf(stderr, "invalid operation: %s\n", argv[2]);
> +		return 1;
> +	}
> +	setfsuid(getuid());
> +
> +	if(mount("", argv[1], "dontcare", type, "") == -1) {
> +		perror("mount");
> +		return 1;
> +	}
> +	return 0;
> +}
> --- lin2627-rc3g4-kerndoc.orig/Documentation/filesystems/sharedsubtree.txt
> +++ lin2627-rc3g4-kerndoc/Documentation/filesystems/sharedsubtree.txt
> @@ -47,6 +47,7 @@ replicas continue to be exactly same.
>  	note: mount command does not yet support the --make-shared flag.
>  	I have included a small C program which does the same by executing
>  	'smount /mnt shared'
> +	[see Documentation/filesystems/smount.c]
>  
>  	#mount --bind /mnt /tmp
>  	The above command replicates the mount at /mnt to the mountpoint /tmp
> @@ -141,87 +142,12 @@ replicas continue to be exactly same.
>  
>  	Currently the mount command is not aware of shared subtree features.
>  	Work is in progress to add the support in mount ( util-linux package ).
> -	Till then use the following program.
> +	Until then use the 'smount' program that is located in
> +	"Documentation/filesystems/smount.c" and build it like:
>  
> -	------------------------------------------------------------------------
> -	//
> -	//this code was developed my Miklos Szeredi <miklos@szeredi.hu>
> -	//and modified by Ram Pai <linuxram@us.ibm.com>
> -	// sample usage:
> -	//              smount /tmp shared
> -	//
> -	#include <stdio.h>
> -	#include <stdlib.h>
> -	#include <unistd.h>
> -	#include <string.h>
> -	#include <sys/mount.h>
> -	#include <sys/fsuid.h>
> -
> -	#ifndef MS_REC
> -	#define MS_REC		0x4000	/* 16384: Recursive loopback */
> -	#endif
> -
> -	#ifndef MS_SHARED
> -	#define MS_SHARED		1<<20	/* Shared */
> -	#endif
> -
> -	#ifndef MS_PRIVATE
> -	#define MS_PRIVATE		1<<18	/* Private */
> -	#endif
> -
> -	#ifndef MS_SLAVE
> -	#define MS_SLAVE		1<<19	/* Slave */
> -	#endif
> -
> -	#ifndef MS_UNBINDABLE
> -	#define MS_UNBINDABLE		1<<17	/* Unbindable */
> -	#endif
> -
> -	int main(int argc, char *argv[])
> -	{
> -		int type;
> -		if(argc != 3) {
> -			fprintf(stderr, "usage: %s dir "
> -			"<rshared|rslave|rprivate|runbindable|shared|slave"
> -			"|private|unbindable>\n" , argv[0]);
> -			return 1;
> -		}
> -
> -		fprintf(stdout, "%s %s %s\n", argv[0], argv[1], argv[2]);
> -
> -		if (strcmp(argv[2],"rshared")==0)
> -			type=(MS_SHARED|MS_REC);
> -		else if (strcmp(argv[2],"rslave")==0)
> -			type=(MS_SLAVE|MS_REC);
> -		else if (strcmp(argv[2],"rprivate")==0)
> -			type=(MS_PRIVATE|MS_REC);
> -		else if (strcmp(argv[2],"runbindable")==0)
> -			type=(MS_UNBINDABLE|MS_REC);
> -		else if (strcmp(argv[2],"shared")==0)
> -			type=MS_SHARED;
> -		else if (strcmp(argv[2],"slave")==0)
> -			type=MS_SLAVE;
> -		else if (strcmp(argv[2],"private")==0)
> -			type=MS_PRIVATE;
> -		else if (strcmp(argv[2],"unbindable")==0)
> -			type=MS_UNBINDABLE;
> -		else {
> -			fprintf(stderr, "invalid operation: %s\n", argv[2]);
> -			return 1;
> -		}
> -		setfsuid(getuid());
> -
> -		if(mount("", argv[1], "dontcare", type, "") == -1) {
> -			perror("mount");
> -			return 1;
> -		}
> -		return 0;
> -	}
> -	-----------------------------------------------------------------------
> -
> -	Copy the above code snippet into smount.c
>  	gcc -o smount smount.c
>  
> +	-----------------------------------------------------------------------
>  
>  	(i) To mark all the mounts under /mnt as shared execute the following
>  	command:
> --- lin2627-rc3g4-kerndoc.orig/Documentation/Makefile
> +++ lin2627-rc3g4-kerndoc/Documentation/Makefile
> @@ -1,3 +1,3 @@
>  obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
> -	filesystems/configfs/ ia64/ networking/ \
> +	filesystems/ filesystems/configfs/ ia64/ networking/ \
>  	pcmcia/ spi/ video4linux/ vm/ watchdog/src/
> --- /dev/null
> +++ lin2627-rc3g4-kerndoc/Documentation/filesystems/Makefile
> @@ -0,0 +1,8 @@
> +# kbuild trick to avoid linker error. Can be omitted if a module is built.
> +obj- := dummy.o
> +
> +# List of programs to build
> +hostprogs-y := smount
> +
> +# Tell kbuild to always build the programs
> +always := $(hostprogs-y)
> --- lin2627-rc3g4-kerndoc.orig/Documentation/filesystems/00-INDEX
> +++ lin2627-rc3g4-kerndoc/Documentation/filesystems/00-INDEX
> @@ -92,6 +92,8 @@ sharedsubtree.txt
>  	- a description of shared subtrees for namespaces.
>  smbfs.txt
>  	- info on using filesystems with the SMB protocol (Win 3.11 and NT).
> +smount.c
> +	- sample source code for mounting shared subtrees
>  spufs.txt
>  	- info and mount options for the SPU filesystem used on Cell.
>  sysfs-pci.txt
> 
> 
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
