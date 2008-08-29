Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYH2J6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYH2J6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYH2J62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:58:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:52649 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752986AbYH2J6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:58:25 -0400
Subject: Re: Linux Kernel Splice Race Condition with page invalidation
From: Miklos Szeredi <mszeredi@suse.cz>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Alexandre LISSY <alexandre.lissy@smartjog.com>
In-Reply-To: <1219940127.6581.194.camel@tucsk>
References: <200808281649.51440.alexandre.lissy@smartjog.com>
	 <1219937801.6581.183.camel@tucsk>
	 <200808281743.58907.alexandre.lissy@smartjog.com>
	 <1219940127.6581.194.camel@tucsk>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 Aug 2008 11:58:21 +0200
Message-Id: <1220003901.6581.201.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot the example programs from the forward, thanks Eugene for the
reminder.

So here they are:

epoll+splice.c
============================================================
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <signal.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <netinet/in.h>

#include <sys/epoll.h>
#include <sys/socket.h>
#include <sys/types.h>

#define MAX_EVENTS 	32
/* #define BUF_SIZE	1400	// ==> ~ 25-30% de CPU à 4096 clients */
/* #define BUF_SIZE	32768	// ==> ~ 50% de CPU à 4096 clients */
/* #define BUF_SIZE	8192	// ==> ~ 35% de CPU à 4096 clients */
#define BUF_SIZE	131072
#define MAX_CONNEXIONS	16384
#define SERVER_IP	"127.0.0.1"
#define SERVER_PORT	8003

typedef enum {
	INITIAL			= 1,
	RECU_REQUETE_CLIENT	= 2,
	ATT_REPONSE_SERVEUR	= 3
} proxy_status ;

struct proxy
{
	unsigned char type;
	int client_fd;	/* fd connected to client */
	int server_fd;  /* fd connected to server */
	/* 
	 * 0 : client
	 * 1 : server
	 */
	ssize_t datalen;
	int curpos;
	proxy_status Statut;
	char * buf;
	struct epoll_event * ev;
	struct proxy * peer;
	int * tube;
};

struct poll {
	void * socks_lock;
/*	void * socks; */
	int socket_fd;
	int epoll_fd;
	struct proxy * pr;
};

/* typedef struct proxy epoll_data_t; */

struct poll gpoll;

/* struct proxy Connexions[MAX_CONNEXIONS];
unsigned int curConnexionsPos = 0; */

void setnonblocking(int fd)
{
	fcntl(fd, F_SETFL, ( fcntl(fd, F_GETFL) | O_NONBLOCK ));
}

/*
 * Init control.
 * Init epoll.
 * Bind and listen on control port.
 */
void 	poll_init_tcp()
{
    struct sockaddr_in  	saddr;
    struct epoll_event		*event;
    struct proxy		*Proxy;
    int 			i = 1;

    /* pthread_mutex_init(&gpoll.socks_lock, NULL);

    gpoll.socks		= NULL; */
    /* Init epoll */
    gpoll.epoll_fd 		= epoll_create(32);
    gpoll.socket_fd		= socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

    event = (struct epoll_event *)malloc(sizeof(struct epoll_event));
    Proxy = (struct proxy *)malloc(sizeof(struct proxy));
    if(event == NULL || Proxy == NULL)
    {
    	perror("malloc()");
	return;
    }
    memset(event, 0, sizeof(struct epoll_event));
    memset(Proxy, 0, sizeof(struct proxy));
    event->events 		= EPOLLIN | EPOLLOUT;
    Proxy->client_fd		= gpoll.socket_fd;
    Proxy->server_fd		= gpoll.socket_fd;
    Proxy->curpos		= 0;
    Proxy->ev			= event;
    event->data.ptr		= Proxy;
    gpoll.pr			= Proxy;

    fprintf(stderr, "Stored fd : %d, %d in %p\n", Proxy->client_fd, Proxy->server_fd, Proxy);

    saddr.sin_family		= AF_INET;
    saddr.sin_addr.s_addr 	= INADDR_ANY;
    saddr.sin_port 		= htons(8080);

    if (gpoll.socket_fd == -1)
        fprintf(stderr, "back-ch: socket SOCK_STREAM: %s\n", strerror(errno));

    if (-1 == setsockopt(gpoll.socket_fd, SOL_SOCKET, SO_REUSEADDR, &i, sizeof (i)))
        fprintf(stderr, "back-ch: setsockopt SO_REUSEADDR: %s\n", strerror(errno));

    if (-1 == bind(gpoll.socket_fd, (struct sockaddr *)&saddr, sizeof (saddr)))
        fprintf(stderr, "back-ch: bind: %s\n", strerror(errno));

    if (-1 == listen(gpoll.socket_fd, 10))
        fprintf(stderr, "ctlchannel: listen: %s\n", strerror(errno));

    if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_ADD, gpoll.socket_fd, event) < 0)
        fprintf(stderr, "cannot control epoll");

    setnonblocking(gpoll.epoll_fd);
}


/*
 * This function accept an incoming connection, add it to epoll, set it to non-blocking mode, 
 * create a new sock struct, fill it and add it to the internal chained list.
 */
void	accept_sock(void)
{
    int sd, dest;
    int * tube;
    struct sockaddr saddr;
    struct sockaddr_in dest_addr;
    struct proxy * Client, * Serveur;
    char * buffer;
    struct epoll_event * evClient, * evServeur;
    socklen_t saddrlen;
    socklen_t dest_addrlen;

    /* Accept connection */
    saddrlen = sizeof(saddr);
    sd = accept(gpoll.socket_fd, &saddr, &saddrlen);

    dest_addrlen = sizeof(dest_addr);
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port   = htons(SERVER_PORT);
    inet_aton(SERVER_IP, &dest_addr.sin_addr);

    dest = socket(PF_INET, SOCK_STREAM, 0); 
    if(dest == -1)
    {
	perror("socket()");
	return;
    }

    if( connect(dest, (struct sockaddr *) &dest_addr, dest_addrlen) == -1 )
    {
	perror("connect()");
	if(shutdown(sd, SHUT_RDWR) == -1)
	{
		perror("shutdown()");
	}
	return;
    }

    tube = (int *)malloc(sizeof(int)*2);
    Client = (struct proxy *)malloc(sizeof(struct proxy));
    Serveur = (struct proxy *)malloc(sizeof(struct proxy));
    evClient = (struct epoll_event *)malloc(sizeof(struct epoll_event));
    evServeur = (struct epoll_event *)malloc(sizeof(struct epoll_event));
    buffer = (char *)malloc(sizeof(char)*BUF_SIZE);
    if(buffer == NULL || tube == NULL || Client == NULL || Serveur == NULL || evClient == NULL || evServeur == NULL)
    {
	perror("malloc()");
	exit(EXIT_FAILURE);
    }

    if(pipe(tube) < 0)
    {
    	perror("pipe()");
	exit(EXIT_FAILURE);
    }

    Client->client_fd	= sd;
    Client->server_fd	= dest;
    Client->curpos	= 0;
    Client->datalen	= 16;
    Client->type	= 0;
    Client->buf		= buffer;
    Client->Statut	= 0;
    Client->ev		= evClient;
    Client->peer	= Serveur;
    Client->tube	= tube;
    Serveur->client_fd	= sd;
    Serveur->server_fd	= dest;
    Serveur->curpos	= 0;
    Serveur->datalen	= 16;
    Serveur->type	= 1;
    Serveur->buf	= buffer;
    Serveur->Statut	= 0;
    Serveur->ev		= evServeur;
    Serveur->peer	= Client;
    Serveur->tube	= tube;

    memset(evClient, 0, sizeof(struct epoll_event));
    memset(evServeur, 0, sizeof(struct epoll_event));
    evClient->events	= EPOLLIN | EPOLLOUT | EPOLLET;
    evClient->data.ptr	= Client;
    evServeur->events	= EPOLLIN | EPOLLOUT | EPOLLET;
    evServeur->data.ptr	= Serveur;


    if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_ADD, sd, evClient))
        fprintf(stderr, "problem with client socket");

    if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_ADD, dest, evServeur))
        fprintf(stderr, "problem with server socket");

    setnonblocking(dest);
    setnonblocking(sd);

#ifdef VERBOSE
    fprintf(stderr, "accept() on fd %d\n", sd);
    fprintf(stderr, "connect() on fd %d\n", dest);
#endif
}

void close_socket(struct proxy * p, unsigned char peer)
{
	int cfd, sfd, result;

	cfd = p->client_fd;
	sfd = p->server_fd;

	if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_DEL, cfd, NULL))
		perror("epoll_ctl()");
	if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_DEL, sfd, NULL))
		perror("epoll_ctl()");

	if(p->type == 0)
	{
#ifdef VERBOSE
		fprintf(stderr, "Freeing buffer @ %p\n", p->buf);
#endif
		free(p->buf);

#ifdef VERBOSE
		fprintf(stderr, "Freeing pipe @ %p\n", p->tube);
#endif
		close(p->tube[0]);
		close(p->tube[1]);
		free(p->tube);
	}
#ifdef VERBOSE
	fprintf(stderr, "Freeing struct epoll_event @ %p\n", p->ev);
#endif
	free(p->ev);
	if(peer == 1)
	{
#ifdef VERBOSE
		fprintf(stderr, "Freeing peer's struct proxy @ %p\n", p->peer);
#endif
		close_socket(p->peer, 0);
	}
#ifdef VERBOSE
	fprintf(stderr, "Freeing struct proxy @ %p\n", p);
#endif
	free(p);

#ifdef VERBOSE
	fprintf(stderr, "Shutting down fds (%d, %d)\n", sfd, cfd);
#endif
	result = shutdown(sfd, SHUT_RDWR);
	if(result == -1)
		perror("shutdown()");

	result = shutdown(cfd, SHUT_RDWR);
	if(result == -1)
		perror("shutdown()");
}

void	poll_loop()
{
    struct epoll_event 	events[MAX_EVENTS];
    int n = 0, repfd = 0, fd = 0;
    long read_incoming, write_incoming, write_outcoming;
    struct proxy * p;
    unsigned char type;

    memset(events, 0, sizeof(struct epoll_event)*MAX_EVENTS);

    for(;;) 
    {
        int nfds = epoll_wait(gpoll.epoll_fd, events, MAX_EVENTS, -1);
        for (n = 0; n < nfds; ++n) 
        {
#ifdef DEBUG
	    fprintf(stderr, "(EPOLLIN=%d, EPOLLOUT=%d, EPOLLRDHUP=%d, EPOLLPRI=%d, EPOLLERR=%d, EPOLLHUP=%d)\n",
	    	events[n].events & EPOLLIN,
	    	events[n].events & EPOLLOUT,
	    	events[n].events & EPOLLRDHUP,
	    	events[n].events & EPOLLPRI,
	    	events[n].events & EPOLLERR,
	    	events[n].events & EPOLLHUP
		);

		fprintf(stderr, "Retrieving user data from %p\n", events[n].data.ptr);
#endif

		p = events[n].data.ptr;
		if (events[n].events & EPOLLIN)
		{
			if (p->server_fd == gpoll.socket_fd && (int)p->client_fd == gpoll.socket_fd)
				accept_sock();
		}

		type	= p->type;
		/**
		 * Type :
		 * 	0 => Client
		 * 	1 => Serveur
		 **/
		switch(type)
		{
			case 0:	fd	= p->client_fd;
				repfd	= p->server_fd;
				break;
			case 1:	fd	= p->server_fd;
				repfd	= p->client_fd;
				break;
		}

		if (events[n].events & EPOLLHUP || events[n].events & EPOLLRDHUP)
		{
			/* Suppression des FDs concernant les sockets morts pour epoll. */
			close_socket(p, 1);
			continue;
		}

            if (events[n].events & EPOLLIN)
            {
#ifdef DEBUG
		fprintf(stderr, "fd %d is ready for reading !\n", fd);
#endif
		if(p->buf != NULL)
		{
			read_incoming = splice(fd, NULL, p->tube[1], NULL, 1400, SPLICE_F_NONBLOCK | SPLICE_F_MORE | SPLICE_F_MOVE);
			if(read_incoming < 0)
			{
				if(errno == EAGAIN)
				{
					fprintf(stderr, "EAGAIN: IN=%d, OUT=%d\n", fd, p->tube[1]);
					continue;
				}
				perror("splice()");
#ifdef DEBUG
				fprintf(stderr, "Was: %ld = splice(%d, %p, %d, %p, %d, %d);\n",
					read_incoming,
					fd,
					NULL,
					p->tube[1],
					NULL,
					12*1024,
					SPLICE_F_NONBLOCK
				);
#endif
				break;
			} else {
				if(read_incoming == 0)
				{
					fprintf(stderr, "Something's wrong. Closing this proxy.\n");
					close_socket(p, 1);
					continue;
				}

#ifdef DEBUG
				fprintf(stderr, "Splice()'d %lu bytes from %d to %d\n", read_incoming, fd, p->tube[1]);
#endif
				write_outcoming = read_incoming;
				while(write_outcoming > 0)
				{
				
					write_incoming = splice(p->tube[0], NULL, repfd, NULL, write_outcoming, SPLICE_F_NONBLOCK | SPLICE_F_MORE | SPLICE_F_MOVE);
					if(write_incoming < 0)
					{
						if(write_incoming == -EAGAIN)
						{
							fprintf(stderr, "EAGAIN: IN=%d, OUT=%d\n", p->tube[0], repfd);
							continue;
						}

						perror("splice()");
						break;
					}
				
					write_outcoming -= write_incoming;
#ifdef DEBUG
					fprintf(stderr, "Splice()'d %lu bytes from %d to %d\n", write_incoming, p->tube[0], repfd);
#endif
#ifdef DEBUG
					fprintf(stderr, "Splice()'d %lu bytes from %d to %d (via %d, %d). Still %lu bytes to send.\n", write_incoming, fd, repfd, p->tube[0], p->tube[1], write_outcoming);
#endif
				}

				switch(type)
				{
					case 0: /* Socket client prêt en lecture */
						break;

					case 1: /* Socket serveur prêt en lecture */
						break;
				}
			}
		}
            }
	}
    }
}

void handler(int signo)
{
	if(signo == SIGTERM || signo == SIGINT)
	{
		fprintf(stderr, "Got SIGTERM or SIGINT, cleaning up things ...\n");
		epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_DEL, gpoll.socket_fd, NULL);
		shutdown(gpoll.socket_fd, SHUT_RDWR);
		free(gpoll.pr->buf);
		free(gpoll.pr->ev);
		free(gpoll.pr);
		exit(EXIT_SUCCESS);
	} else {
		fprintf(stderr, "UNKNOWN SIGNAL !!! : %d\n", signo);
	}
}

int main(int argc, char ** argv)
{
	signal(SIGTERM, handler);
	signal(SIGINT, handler);
	poll_init_tcp();
	poll_loop();

	return EXIT_SUCCESS;
}
============================================================


﻿epoll.c
============================================================
﻿#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <netinet/in.h>

#include <sys/epoll.h>
#include <sys/socket.h>
#include <sys/types.h>

#define MAX_EVENTS 	2
/* #define BUF_SIZE	1400	// ==> ~ 25-30% de CPU à 4096 clients */
/* #define BUF_SIZE	32768	// ==> ~ 50% de CPU à 4096 clients */
#define BUF_SIZE	1400	// ==> ~ 35% de CPU à 4096 clients
#define MAX_CONNEXIONS	16384
#define SERVER_IP	"127.0.0.1"
#define SERVER_PORT	8003

typedef enum {
	INITIAL			= 1,
	RECU_REQUETE_CLIENT	= 2,
	ATT_REPONSE_SERVEUR	= 3
} proxy_status ;

struct proxy
{
	unsigned char type;
	int client_fd;	/* fd connected to client */
	int server_fd;  /* fd connected to server */
	/* 
	 * 0 : client
	 * 1 : server
	 */
	ssize_t datalen;
	int curpos;
	proxy_status Statut;
	char * buf;
	struct epoll_event * ev;
	struct proxy * peer;
};

struct poll {
	void * socks_lock;
/*	void * socks; */
	int socket_fd;
	int epoll_fd;
	struct proxy * pr;
};

/* typedef struct proxy epoll_data_t; */

struct poll gpoll;

/* struct proxy Connexions[MAX_CONNEXIONS];
unsigned int curConnexionsPos = 0; */

void setnonblocking(int fd)
{
	fcntl(fd, F_SETFL, ( fcntl(fd, F_GETFL) | O_NONBLOCK ));
}

/**
 * Recherche du FD de l'autre entité.
 *
 * type :
 * 	0 => client
 * 	1 => serveur
int find_peer(int fd, struct proxy ** target, unsigned char * type)
{
	int i, found_fd;
	struct proxy *p;

	fprintf(stderr, "Looking for fd %d\n", fd);
	for(i = 0; i < curConnexionsPos; i++)
	{
		p = &Connexions[i];
		fprintf(stderr, "p->client_fd=%d\np->server_fd=%d\n\n", p->client_fd, p->server_fd);

		if(p->client_fd == fd)
		{
			found_fd = p->server_fd;
			*type	 = 0;
		}
		else if(p->server_fd == fd)
		{
			found_fd = p->client_fd;
			*type    = 1;
		}

		*target = p;
		fprintf(stderr, "Found at p=%p\n", p);

		return found_fd;
	}

	errno = EBADF;
	return -1;
}
*/

/*
 * Init control.
 * Init epoll.
 * Bind and listen on control port.
 */
void 	poll_init_tcp()
{
    struct sockaddr_in  	saddr;
    struct epoll_event		*event;
    struct proxy		*Proxy;
    int 			i = 1;

    /* pthread_mutex_init(&gpoll.socks_lock, NULL);

    gpoll.socks		= NULL; */
    /* Init epoll */
    gpoll.epoll_fd 		= epoll_create(2);
    gpoll.socket_fd		= socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

    event = (struct epoll_event *)malloc(sizeof(struct epoll_event));
    Proxy = (struct proxy *)malloc(sizeof(struct proxy));
    if(event == NULL || Proxy == NULL)
    {
    	perror("malloc()");
	return;
    }
    memset(event, 0, sizeof(struct epoll_event));
    memset(Proxy, 0, sizeof(struct proxy));
    event->events 		= EPOLLIN | EPOLLOUT;
    Proxy->client_fd		= gpoll.socket_fd;
    Proxy->server_fd		= gpoll.socket_fd;
    Proxy->curpos		= 0;
    Proxy->ev			= event;
    event->data.ptr		= Proxy;
    gpoll.pr			= Proxy;

    fprintf(stderr, "Stored fd : %d, %d in %p\n", Proxy->client_fd, Proxy->server_fd, Proxy);

    saddr.sin_family		= AF_INET;
    saddr.sin_addr.s_addr 	= INADDR_ANY;
    saddr.sin_port 		= htons(8080);

    if (gpoll.socket_fd == -1)
        fprintf(stderr, "back-ch: socket SOCK_STREAM: %s\n", strerror(errno));

    if (-1 == setsockopt(gpoll.socket_fd, SOL_SOCKET, SO_REUSEADDR, &i, sizeof (i)))
        fprintf(stderr, "back-ch: setsockopt SO_REUSEADDR: %s\n", strerror(errno));

    if (-1 == bind(gpoll.socket_fd, (struct sockaddr *)&saddr, sizeof (saddr)))
        fprintf(stderr, "back-ch: bind: %s\n", strerror(errno));

    if (-1 == listen(gpoll.socket_fd, 10))
        fprintf(stderr, "ctlchannel: listen: %s\n", strerror(errno));

    if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_ADD, gpoll.socket_fd, event) < 0)
        fprintf(stderr, "cannot control epoll");

    setnonblocking(gpoll.epoll_fd);
}


/*
 * This function accept an incoming connection, add it to epoll, set it to non-blocking mode, 
 * create a new sock struct, fill it and add it to the internal chained list.
 */
void	accept_sock(void)
{
    int sd, dest;
    struct sockaddr saddr;
    struct sockaddr_in dest_addr;
    struct proxy * Client, * Serveur;
    char * buffer;
    struct epoll_event * evClient, * evServeur;
    socklen_t saddrlen;
    socklen_t dest_addrlen;

    /* Accept connection */
    saddrlen = sizeof(saddr);
    sd = accept(gpoll.socket_fd, &saddr, &saddrlen);

    dest_addrlen = sizeof(dest_addr);
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port   = htons(SERVER_PORT);
    inet_aton(SERVER_IP, &dest_addr.sin_addr);

    dest = socket(PF_INET, SOCK_STREAM, 0); 
    if(dest == -1)
    {
	perror("socket()");
	return;
    }

    if( connect(dest, (struct sockaddr *) &dest_addr, dest_addrlen) == -1 )
    {
	perror("connect()");
	if(shutdown(sd, SHUT_RDWR) == -1)
	{
		perror("shutdown()");
	}
	return;
    }

    Client = (struct proxy *)malloc(sizeof(struct proxy));
    Serveur = (struct proxy *)malloc(sizeof(struct proxy));
    evClient = (struct epoll_event *)malloc(sizeof(struct epoll_event));
    evServeur = (struct epoll_event *)malloc(sizeof(struct epoll_event));
    buffer = (char *)malloc(sizeof(char)*BUF_SIZE);
    if(buffer == NULL || Client == NULL || Serveur == NULL || evClient == NULL || evServeur == NULL)
    {
	perror("malloc()");
	exit(EXIT_FAILURE);
    }

    Client->client_fd	= sd;
    Client->server_fd	= dest;
    Client->curpos	= 0;
    Client->datalen	= 16;
    Client->type	= 0;
    Client->buf		= buffer;
    Client->Statut	= 0;
    Client->ev		= evClient;
    Client->peer	= Serveur;
    Serveur->client_fd	= sd;
    Serveur->server_fd	= dest;
    Serveur->curpos	= 0;
    Serveur->datalen	= 16;
    Serveur->type	= 1;
    Serveur->buf	= buffer;
    Serveur->Statut	= 0;
    Serveur->ev		= evServeur;
    Serveur->peer	= Client;

    memset(evClient, 0, sizeof(struct epoll_event));
    memset(evServeur, 0, sizeof(struct epoll_event));
    evClient->events	= EPOLLIN | EPOLLOUT | EPOLLET;
    evClient->data.ptr	= Client;
    evServeur->events	= EPOLLIN | EPOLLOUT | EPOLLET;
    evServeur->data.ptr	= Serveur;


    if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_ADD, sd, evClient))
        fprintf(stderr, "problem with client socket");

    if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_ADD, dest, evServeur))
        fprintf(stderr, "problem with server socket");

    setnonblocking(dest);
    setnonblocking(sd);

#ifdef VERBOSE
    fprintf(stderr, "accept() on fd %d\n", sd);
    fprintf(stderr, "connect() on fd %d\n", dest);
#endif
}

void close_socket(struct proxy * p, unsigned char peer)
{
	int cfd, sfd, result;

	cfd = p->client_fd;
	sfd = p->server_fd;

	if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_DEL, cfd, NULL))
		perror("epoll_ctl()");
	if (epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_DEL, sfd, NULL))
		perror("epoll_ctl()");

	if(p->type == 0)
	{
#ifdef VERBOSE
		fprintf(stderr, "Freeing buffer @ %p\n", p->buf);
#endif
		free(p->buf);
	}
#ifdef VERBOSE
	fprintf(stderr, "Freeing struct epoll_event @ %p\n", p->ev);
#endif
	free(p->ev);
	if(peer == 1)
	{
#ifdef VERBOSE
		fprintf(stderr, "Freeing peer's struct proxy @ %p\n", p->peer);
#endif
		close_socket(p->peer, 0);
	}
#ifdef VERBOSE
	fprintf(stderr, "Freeing struct proxy @ %p\n", p);
#endif
	free(p);

#ifdef VERBOSE
	fprintf(stderr, "Shutting down fds (%d, %d)\n", sfd, cfd);
#endif
	result = shutdown(sfd, SHUT_RDWR);
	if(result == -1)
		perror("shutdown()");

	result = shutdown(cfd, SHUT_RDWR);
	if(result == -1)
		perror("shutdown()");
}

void	poll_loop()
{
    struct epoll_event 	events[MAX_EVENTS];
    int n = 0, repfd = 0, fd = 0;
    ssize_t read_incoming, write_outcoming, copied;
    struct proxy * p;
    unsigned char type;

    memset(events, 0, sizeof(struct epoll_event)*MAX_EVENTS);

    for(;;) 
    {
        int nfds = epoll_wait(gpoll.epoll_fd, events, MAX_EVENTS, -1);
        for (n = 0; n < nfds; ++n) 
        {
#ifdef DEBUG
	    fprintf(stderr, "(EPOLLIN=%d, EPOLLOUT=%d, EPOLLRDHUP=%d, EPOLLPRI=%d, EPOLLERR=%d, EPOLLHUP=%d)\n",
	    	events[n].events & EPOLLIN,
	    	events[n].events & EPOLLOUT,
	    	events[n].events & EPOLLRDHUP,
	    	events[n].events & EPOLLPRI,
	    	events[n].events & EPOLLERR,
	    	events[n].events & EPOLLHUP
		);

		fprintf(stderr, "Retrieving user data from %p\n", events[n].data.ptr);
#endif

		p = events[n].data.ptr;
		if (events[n].events & EPOLLIN)
		{
			if (p->server_fd == gpoll.socket_fd && (int)p->client_fd == gpoll.socket_fd)
				accept_sock();
		}

		type	= p->type;
		/**
		 * Type :
		 * 	0 => Client
		 * 	1 => Serveur
		 **/
		switch(type)
		{
			case 0:	fd	= p->client_fd;
				repfd	= p->server_fd;
				break;
			case 1:	fd	= p->server_fd;
				repfd	= p->client_fd;
				break;
		}

		if (events[n].events & EPOLLHUP)
		{
			/* Suppression des FDs concernant les sockets morts pour epoll. */
			close_socket(p, 1);
			continue;
		}

            if (events[n].events & EPOLLIN)
            {
#ifdef DEBUG
		fprintf(stderr, "fd %d is ready for reading into %p.\n", fd, p->buf);
#endif
		if(p->buf != NULL)
		{
			read_incoming = read(fd, p->buf, BUF_SIZE);
			p->datalen = read_incoming;

#ifdef DEBUG
			fprintf(stderr, "Read %d bytes from %d.\n", read_incoming, fd);
#endif

			if(read_incoming == 0)
			{
				fprintf(stderr, "Something's wrong on fd %d : I got no data.\n", fd);
				/* close_socket(p, 1); */
				continue;
			}

			copied = write(repfd, p->buf, p->datalen);
			p->datalen -= copied;

			switch(type)
			{
				case 0: /* Socket client prêt en lecture */
					break;

				case 1: /* Socket serveur prêt en lecture */
					break;
			}
		}
            }
/*
            else if (events[n].events & EPOLLOUT)
            {
#ifdef DEBUG
		fprintf(stderr, "fd %d is ready for writing. ", fd);
#endif
		if(p != NULL && p->buf != NULL && p->datalen > 0)
		{
			write_outcoming = write(fd, p->buf, p->datalen);
			p->datalen -= write_outcoming;
#ifdef DEBUG
			fprintf(stderr, "Write %d bytes to %d.\n", write_outcoming, fd);
#endif
			switch(type)
			{
				case 0: // Socket client prêt en écriture
					break;

				case 1: // Socket serveur prêt en écriture
					break;
			}
		}
            }
*/
	}
    }
}

void handler(int signo)
{
	if(signo == SIGTERM || signo == SIGINT)
	{
		fprintf(stderr, "Got SIGTERM or SIGINT, cleaning up things ...\n");
		epoll_ctl(gpoll.epoll_fd, EPOLL_CTL_DEL, gpoll.socket_fd, NULL);
		shutdown(gpoll.socket_fd, SHUT_RDWR);
		free(gpoll.pr->buf);
		free(gpoll.pr->ev);
		free(gpoll.pr);
		exit(EXIT_SUCCESS);
	} else {
		fprintf(stderr, "UNKNOWN SIGNAL !!! : %d\n", signo);
	}
}

int main(int argc, char ** argv)
{
	signal(SIGTERM, handler);
	signal(SIGINT, handler);
	poll_init_tcp();
	poll_loop();

	return EXIT_SUCCESS;
}
============================================================



On Thu, 2008-08-28 at 18:15 +0200, Miklos Szeredi wrote:
> Thanks, forwarding to mailing lists.
> 
> Since you are in a better position to test (already have the
> installation and configuration set up) I'm not going to try to reproduce
> this until you tried 2.6.26.
> 
> Thanks,
> Miklos
> 
> On Thu, 2008-08-28 at 17:43 +0200, Alexandre LISSY wrote:
> > Le Thursday 28 August 2008 17:36:41, vous avez écrit :
> > > Hi Alexandre,
> > >
> > > On Thu, 2008-08-28 at 16:49 +0200, Alexandre LISSY wrote:
> > > > I saw your mail on LKML, and I feel like I'm experiencing the issue.
> > > > I'm using a 2.6.25-2-amd64 (from Debian), on two machines, one with 32
> > > > bits user land, and the other with 64 bits userland. I also tried with
> > > > 2.6.25-2-686.
> > >
> > > Thanks for the report.  Usually it's best to send such a report not just
> > > to an individual developer, but to relevant mailing lists as well (in
> > > this case <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>).
> > > Would you mind if I forwarded your mail to these lists?
> > No problem, I wasn't sure this was the good audience.
> > 
> > >
> > > > I'm trying to achieve a really fast tcp proxy, mostly for testing
> > > > purpose. Attached is my code, so you can check, and maybe reproduce :)
> > >
> > > Thanks.  I don't know how I can use these programs to reproduce the
> > > problem.  Can you please describe in detail how to set up and run the
> > > test environment?
> > Just compile my code, install a icecast that provide a 128k mp3 stream.
> > Pay attention, the addresses are hardcoded in source, so you need to recompile 
> > for any change.
> > 
> > Then, launch many wget or any other tool capable of parallel download, to 
> > stress the proxy.
> > 
> > >
> > > > If I use the local icecast (the one on 127.0.0.1), then, I can reach
> > > > 62Mbits, if kernel didn't trashed in the middle of the operation (confere
> > > > "Kernel having fun"), leaving my process unkillable. Need to reboot :/.
> > >
> > > This is because of the kernel BUG that you've reported below.  I found
> > > this similar report:
> > Yeah, I figured that's linked :)
> > 
> > >
> > >   http://article.gmane.org/gmane.linux.network/94988
> > >
> > > This may have been fixed in linux-2.6.26.  Could you try a 2.6.26
> > > kernel, to see if you can still reproduce the problem?
> > I'll grab a 2.6.26 from unstable tomorrow and check if it continues to 
> > happens.
> > 
> > Thanks for your help :)
> > 
> > >
> > > Thanks,
> > > Miklos
> > >
> > > > And while it's not trashed, I get many "splice(): Resource temporarily
> > > > unavailable", that don't come up when using a remote icecast.
> > > >
> > > > So, as the only difference is local/remote, I think that latency matters,
> > > > and considering your message about a race condition, I'm wondering ...
> > > >
> > > > Thanks for any help/hint !
> > > >
> > > > ---Kernel having fun---
> > > > [65611.886737] BUG: unable to handle kernel NULL pointer dereference at
> > > > 0000000000000008
> > > > [65611.886737] IP: [<ffffffff803db40d>] tcp_read_sock+0xec/0x1a3
> > > > [65611.886737] PGD 1fc64067 PUD 2f2a7067 PMD 0
> > > > [65611.886737] Oops: 0002 [1] SMP
> > > > [65611.886737] CPU 1
> > > > [65611.886737] Modules linked in: ipv6 bonding dm_snapshot dm_mirror
> > > > dm_mod loop iTCO_wdt ses i5000_edac pcspkr psmouse evdev dcdbas rng_core
> > > > button edac_core ixgbe shpchp pci_hotplug serio_raw enclosure ext3 jbd
> > > > mbcache raid1 md_mod ide_generic ide_cd_mod cdrom ata_generic libata dock
> > > > sd_mod piix ide_core ehci_hcd uhci_hcd megaraid_sas bnx2 firmware_class
> > > > scsi_mod thermal processor fan
> > > > [65611.886737] Pid: 18679, comm: epoll+splice+st Not tainted
> > > > 2.6.25-2-amd64 #1 [65611.886737] RIP: 0010:[<ffffffff803db40d>] 
> > > > [<ffffffff803db40d>] tcp_read_sock+0xec/0x1a3
> > > > [65611.886737] RSP: 0018:ffff81006db59e68  EFLAGS: 00010202
> > > > [65611.886737] RAX: 0000000000000000 RBX: ffff810073c504a0 RCX:
> > > > 0000000000000000
> > > > [65611.886737] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> > > > ffff810073c504a0
> > > > [65611.886737] RBP: 0000000000000578 R08: ffff81006d5a2080 R09:
> > > > 0000000000000000
> > > > [65611.886737] R10: ffff810065663980 R11: ffffffff802f0637 R12:
> > > > 0000000000000578
> > > > [65611.886737] R13: ffff81006d5a2080 R14: 000000001e5b23ed R15:
> > > > ffff81006d5a2130
> > > > [65611.886737] FS:  0000000000be2850(0063) GS:ffff81007f76db40(0000)
> > > > knlGS:0000000000000000
> > > > [65611.886737] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > [65611.886737] CR2: 0000000000000008 CR3: 0000000061b55000 CR4:
> > > > 00000000000006e0
> > > > [65611.886737] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000
> > > > [65611.886737] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > > > 0000000000000400
> > > > [65611.886737] Process epoll+splice+st (pid: 18679, threadinfo
> > > > ffff81006db58000, task ffff81007ee45180)
> > > > [65611.886737] Stack:  ffffffff803db596 ffff81006db59eb8 000005782628a210
> > > > ffff81006d5a2080
> > > > [65611.886737]  0000000000000000 0000000000000000 0000000000000007
> > > > 0000000000000000
> > > > [65611.886737]  0000000000000578 ffffffff803dbb14 0000000000000000
> > > > 0000000000000000
> > > > [65611.886737] Call Trace:
> > > > [65611.886737]  [<ffffffff803db596>] ? tcp_splice_data_recv+0x0/0x1c
> > > > [65611.886737]  [<ffffffff803dbb14>] ? tcp_splice_read+0x82/0x1ce
> > > > [65611.886737]  [<ffffffff802b7962>] ? sys_splice+0x1b0/0x23e
> > > > [65611.886737]  [<ffffffff8020bd9a>] ? system_call_after_swapgs+0x8a/0x8f
> > > > [65611.886737]
> > > > [65611.886737]
> > > > [65611.886737] Code: 00 00 00 f6 44 10 0d 01 0f 85 67 ff ff ff 41 ff 4f
> > > > 10 48 89 df 48 8b 43 08 48 8b 13 48 c7 43 08 00 00 00 00 48 c7 03 00 00
> > > > 00 00 <48> 89 42 08 48 89 10 e8 ab 1b fd ff 48 8b 44 24 08 48 83 78 08
> > > > [65611.886737] RIP  [<ffffffff803db40d>] tcp_read_sock+0xec/0x1a3
> > > > [65611.886737]  RSP <ffff81006db59e68>
> > > > [65611.886737] CR2: 0000000000000008
> > > > [65611.886774] ---[ end trace 8f47273d77faf3c8 ]---
> > > > ---Kernel having fun---
> > 
> > 
> 

