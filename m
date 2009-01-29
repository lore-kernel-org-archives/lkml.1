Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZA2DRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZA2DRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZA2DRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:17:36 -0500
Received: from kroah.org ([198.145.64.141]:39804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751433AbZA2DRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:17:34 -0500
Date: Wed, 28 Jan 2009 19:13:49 -0800
From: Greg KH <greg@kroah.com>
To: mtk.manpages@gmail.com
Cc: Robert Hancock <hancockr@shaw.ca>, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090129031349.GA23722@kroah.com>
References: <20090128213322.GA15789@kroah.com> <4980FB4D.9090009@shaw.ca> <20090129011758.GA26534@kroah.com> <cfd18e0f0901281859u250f202fj3ef40fb8531f1dc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <cfd18e0f0901281859u250f202fj3ef40fb8531f1dc3@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 29, 2009 at 03:59:12PM +1300, Michael Kerrisk wrote:
> On Thu, Jan 29, 2009 at 2:17 PM, Greg KH <greg@kroah.com> wrote:
> >
> >
> >
> > On Wed, Jan 28, 2009 at 06:41:49PM -0600, Robert Hancock wrote:
> >>
> >>
> >> Greg KH wrote:
> >>> In looking at open(2), it says that O_DIRECT works on 512 byte boundries
> >>> with the 2.6 kernel release:
> >>>      Under Linux 2.4, transfer sizes, and the alignment of the user
> >>>      buffer and  the file offset must all be multiples of the logical
> >>>      block size of the file system.  Under Linux 2.6, alignment  to
> >>>      512-byte  boundaries suffices.
> >>> However if you try to access an O_DIRECT opened file with a buffer that
> >>> is PAGE_SIZE aligned + 512 bytes, it fails in a bad way (wrong data is
> >>> read.)
> >>> Is this just a mistake in the documentation?  Or am I reading it
> >>> incorrectly?
> >>> I have a test program that shows this if anyone wants it.
> >>
> >> Well, it sounds like a bug to me.. even if it's not supported, if you do
> >> such an access, surely the kernel should detect that and return EINVAL or
> >> something rather than reading corrupted data..
> >
> > It doesn't.  It says the read is successful, yet the data is not really
> > read into the buffer.  Portions of it is, but not the amount we asked
> > for.
> 
> Greg,
> 
> Can you post your test program?

Sure, here it is.  I'm still not quite sure it is valid, but at first
glance it seems to be.

Run it once with no arguments and all of the files will be created.
Then run it again with no offset being asked for:
	./dma_thread -a 0
then with an offset:
	./dma_thread -a 512

The second one breaks.

thanks,

greg k-h

--W/nzBZO5zC0uMSeA
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="dma_thread.c"

/* compile with 'gcc -g -o dma_thread dma_thread.c -lpthread' */

#define _GNU_SOURCE 1

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <memory.h>
#include <pthread.h>
#include <getopt.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>

#define FILESIZE (12*1024*1024) 
#define READSIZE  (1024*1024)

#define FILENAME    "test_%.04d.tmp"
#define FILECOUNT   100
#define MIN_WORKERS 2
#define MAX_WORKERS 256
#define PAGE_SIZE   4096

#define true	1
#define false	0

typedef int bool;

bool	done	= false;
int	workers = 2;

#define PATTERN (0xfa)

static void
usage (void)
{
    fprintf(stderr, "\nUsage: dma_thread [-h | -a <alignment> [ -w <workers>]\n"
		    "\nWith no arguments, generate test files and exit.\n"
		    "-h Display this help and exit.\n"
		    "-a align read buffer to offset <alignment>.\n"
		    "-w number of worker threads, 2 (default) to 256,\n"
		    "   defaults to number of cores.\n\n"

		    "Run first with no arguments to generate files.\n"
		    "Then run with -a <alignment> = 512  or 0. \n");
}

typedef struct {
    pthread_t	    tid;
    int		    worker_number;
    int		    fd;
    int		    offset;
    int		    length;
    int		    pattern;
    unsigned char  *buffer;
} worker_t;


void *worker_thread(void * arg)
{
    int		    bytes_read;
    int		    i,k;
    worker_t	   *worker  = (worker_t *) arg;
    int		    offset  = worker->offset;
    int		    fd	    = worker->fd;
    unsigned char  *buffer  = worker->buffer;
    int		    pattern = worker->pattern;
    int		    length  = worker->length;
    
    if (lseek(fd, offset, SEEK_SET) < 0) {
	fprintf(stderr, "Failed to lseek to %d on fd %d: %s.\n", 
			offset, fd, strerror(errno));
	exit(1);
    }

    bytes_read = read(fd, buffer, length);
    if (bytes_read != length) {
	fprintf(stderr, "read failed on fd %d: bytes_read %d, %s\n", 
			fd, bytes_read, strerror(errno));
	exit(1);
    }

    /* Corruption check */
    for (i = 0; i < length; i++) {
	if (buffer[i] != pattern) {
	    printf("Bad data at 0x%.06x: %p, \n", i, buffer + i);
	    printf("Data dump starting at 0x%.06x:\n", i - 8);
	    printf("Expect 0x%x followed by 0x%x:\n",
		    pattern, PATTERN);

	    for (k = 0; k < 16; k++) {
		printf("%02x ", buffer[i - 8 + k]);
		if (k == 7) {
		    printf("\n");
		}       
	    }

	    printf("\n");
	    abort();
	}
    }

    return 0;
}

void *fork_thread (void *arg) 
{
    pid_t pid;

    while (!done) {
	pid = fork();
	if (pid == 0) {
	    exit(0);
	} else if (pid < 0) {
	    fprintf(stderr, "Failed to fork child.\n");
	    exit(1);
	} 
	waitpid(pid, NULL, 0 );
	usleep(100);
    }

    return NULL;

}

int main(int argc, char *argv[])
{
    unsigned char  *buffer = NULL;
    char	    filename[1024];
    int		    fd;
    bool	    dowrite = true;
    pthread_t	    fork_tid;
    int		    c, n, j;
    worker_t	   *worker;
    int		    align = 0;
    int		    offset, rc;

    workers = sysconf(_SC_NPROCESSORS_ONLN);

    while ((c = getopt(argc, argv, "a:hw:")) != -1) {
	switch (c) {
	case 'a':
	    align = atoi(optarg);
	    if (align < 0 || align > PAGE_SIZE) {
		printf("Bad alignment %d.\n", align);
		exit(1);
	    }
	    dowrite = false;
	    break;

	case 'h':
	    usage();
	    exit(0);
	    break;

	case 'w':
	    workers = atoi(optarg);
	    if (workers < MIN_WORKERS || workers > MAX_WORKERS) {
		fprintf(stderr, "Worker count %d not between "
				"%d and %d, inclusive.\n",
				workers, MIN_WORKERS, MAX_WORKERS);
		usage();
		exit(1);
	    }
	    dowrite = false;
	    break;

	default:
	    usage();
	    exit(1);
	}
    }

    if (argc > 1 && (optind < argc)) {
	fprintf(stderr, "Bad command line.\n");
	usage();
	exit(1);
    }

    if (dowrite) {

	buffer = malloc(FILESIZE);
	if (buffer == NULL) {
	    fprintf(stderr, "Failed to malloc write buffer.\n");
	    exit(1);
	}

	for (n = 1; n <= FILECOUNT; n++) {
	    sprintf(filename, FILENAME, n);
	    fd = open(filename, O_RDWR|O_CREAT|O_TRUNC, 0666);
	    if (fd < 0) {
		printf("create failed(%s): %s.\n", filename, strerror(errno));
		exit(1);
	    }
	    memset(buffer, n, FILESIZE);
	    printf("Writing file %s.\n", filename);
	    if (write(fd, buffer, FILESIZE) != FILESIZE) {
		printf("write failed (%s)\n", filename);
	    }

	    close(fd);
	    fd = -1;
	}

	free(buffer);
	buffer = NULL;

	printf("done\n");
	exit(0);
    }

    printf("Using %d workers.\n", workers);

    worker = malloc(workers * sizeof(worker_t));
    if (worker == NULL) {
	fprintf(stderr, "Failed to malloc worker array.\n");
	exit(1);
    }

    for (j = 0; j < workers; j++) {
	worker[j].worker_number = j;
    }

    printf("Using alignment %d.\n", align);
    
    posix_memalign((void *)&buffer, PAGE_SIZE, READSIZE+ align);
    printf("Read buffer: %p.\n", buffer);
    for (n = 1; n <= FILECOUNT; n++) {

	sprintf(filename, FILENAME, n);
	for (j = 0; j < workers; j++) {
	    if ((worker[j].fd = open(filename,  O_RDONLY|O_DIRECT)) < 0) {
		fprintf(stderr, "Failed to open %s: %s.\n",
				filename, strerror(errno));
		exit(1);
	    }

	    worker[j].pattern = n;
	}

	printf("Reading file %d.\n", n);

	for (offset = 0; offset < FILESIZE; offset += READSIZE) {
	    memset(buffer, PATTERN, READSIZE + align);
	    for (j = 0; j < workers; j++) {
		worker[j].offset = offset + j * PAGE_SIZE;
		worker[j].buffer = buffer + align + j * PAGE_SIZE;
		worker[j].length = PAGE_SIZE;
	    }
	    /* The final worker reads whatever is left over. */
	    worker[workers - 1].length = READSIZE - PAGE_SIZE * (workers - 1);

	    done = 0;

	    rc = pthread_create(&fork_tid, NULL, fork_thread, NULL);
	    if (rc != 0) {
		fprintf(stderr, "Can't create fork thread: %s.\n", 
				strerror(rc));
		exit(1);
	    }

	    for (j = 0; j < workers; j++) {
		rc = pthread_create(&worker[j].tid, 
				    NULL, 
				    worker_thread, 
				    worker + j);
		if (rc != 0) {
		    fprintf(stderr, "Can't create worker thread %d: %s.\n", 
				    j, strerror(rc));
		    exit(1);
		}
	    }

	    for (j = 0; j < workers; j++) {
		rc = pthread_join(worker[j].tid, NULL);
		if (rc != 0) {
		    fprintf(stderr, "Failed to join worker thread %d: %s.\n",
				    j, strerror(rc));
		    exit(1);
		}
	    }

	    /* Let the fork thread know it's ok to exit */
	    done = 1;

	    rc = pthread_join(fork_tid, NULL);
	    if (rc != 0) {
		fprintf(stderr, "Failed to join fork thread: %s.\n",
				strerror(rc));
		exit(1);
	    }
	}

	/* Close the fd's for the next file. */
	for (j = 0; j < workers; j++) {
	    close(worker[j].fd);
	}
    }

    return 0;
}

--W/nzBZO5zC0uMSeA--
