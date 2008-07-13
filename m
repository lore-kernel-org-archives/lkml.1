Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYGMI4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYGMI4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 04:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYGMI4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 04:56:07 -0400
Received: from phunq.net ([64.81.85.152]:59456 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752673AbYGMI4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 04:56:00 -0400
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Improved versioned pointer algorithms
Date: Sun, 13 Jul 2008 01:55:57 -0700
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com,
       zfs-discuss@opensolaris.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_eMceIWz5TxQXOjH"
Message-Id: <200807130155.58011.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_eMceIWz5TxQXOjH
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings, filesystem algorithm fans.

The recent, detailed description of the versioned pointer method for
volume versioning is here:

   http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-07/msg02663.html

I apologize humbly for the typo in the first sentence.  Today's revision
of the proof of concept code is cleaned up to remove some redundant
logic from the exception delete and origin write algorithms, and has
a number of small improvements.  The fuzzing test has run to 20 million
iterations without problems.  Some of the more complex logic has become
simple to the point where it can possibly be seen to be correct in
addition to merely running correctly.

The current efficiency scores for the six basic operations are:

   Origin write:         O(exceptions)
   Snapshot write:       O(versions)
   Snapshot delete:      O(versions)
   Snapshot read:        O(exceptions)
   Snapshot of origin:   O(versions)
   Snapshot of snapshot: O(versions)

This is mainly about CPU time rather than filesystem efficiency.  The
real time performance will be dominated by disk operations as usual.

Snapshot write is a frequent operation and snapshot delete is performed
on large amounts of metadata at a time, so it would be nice to improve
their performance to be independent of the number of versions created.

O(exceptions) orphan test
-------------------------

It is only the orphan searches that increase snapshot write and
snapshot delete running times from O(exceptions) to O(versions),
otherwise the main algorithm is already O(exceptions).

The orphan test is used in snapshot write and exception delete to
identify any new orphans created as a result of a write that creates an
exclusive exception for the only heir of the ghost exception, or a
delete that removes the only heir and does not promote a new heir.

The current method of determining whether a ghost exception is an
orphan is to recurse through the subtree below the ghost until a visible
version is found that inherits the exception.  This traversal runs in 
O(versions) time.

To perform this test in O(exceptions) time, we proceed as follows:

First, identify a subtree of the version tree consisting only of ghost
versions in interior nodes and visible versions at terminal nodes,
descending from the ghost ancestor of the victim version nearest the
root and having no visible versions or present exceptions between itself
and the victim.  Call each interior node of that subtree a "nexus",
which must have more than one child because it is a ghost.  This step
is done once, prior to a full-tree version delete pass.

The interesting question is whether a ghost exception is inherited
by any visible version that does not appear in the same exception list.
If not, then the ghost exception is an orphan that must be deleted.

This can be computed efficiently using a bottom up approach with a
single pass through the exception list.  At each nexus keep a count of
the children of the nexus that are known not to inherit from that
nexus.  Call that the blocked count.  Set the blocked counts to zero
and:

   For each exception in the exception list:
      If the version labeled by the exception is in the ghost
      tree then increment the blocked count of the nexus parent

      If the blocked count is now equal to the number of children
      of the nexus then repeat from the preceding step

At completion, if the blocked count of the ghost ancestor is equal to
its child count then the ghost exception is an orphan, otherwise not.

Example
-------

Below, ghost versions are marked with ~ and members of the ghost tree
are marked with *.

.
`-- A
    |-- B
    `-- *C~
        |-- *D
        |-- E <== victim to be deleted
        `-- *F~
            |-- *G
            `-- *H
                |-- I
                `-- J

Version C is the single ghost ancestor (there may be more than one) that
may contain an orphan exception.  D does not belong to the ghost tree
because it is to be deleted and has already been removed from the
version tree when the ghost tree is constructed.  The interior nexus
nodes are C and F while D, G and H are terminal, user visible nodes of
the ghost tree.

Overlaying the exception list [I, p1] [G, p2] [C, p3] [D, p4] on the
example tree:

.
`-- A
    |-- B
    `-- *C~ [p3]
        |-- *D [p4]
        |-- E <== deleted victim
        `-- *F~
            |-- *G [p2]
            `-- *H
                |-- I [p1]
                `-- J

When exception [I, p1] is found it is ignored because it is not a member
of the ghost tree.  H has no exception, so [G, p2] cannot cause the
algorithm to iterate past node F.  Processing [D, p4] will raise the
nexus count at C to one, but C has two children after ignoring E (which
is deleted by this time) so [C, p3] is not an orphan.  Examining the
tree shows that visible version H continues to inherit the ghost
exception at C, which could now be relabeled to H if desired, but since
it will be detected and deleted in the fullness of time anyway there
is little point in doing that extra work here.

If any of versions F, H or J had an exception then [C, p3] would be an
orphan.

O(log(exceptions)) snapshot lookup
----------------------------------

An O(log(exceptions)) snapshot lookup is known to exist and is left as
an exercise for the interested reader.

Updated versioned pointers fuzztest attached
--------------------------------------------

   c99 fuzzversion.c && ./a.out

Request for comment from Btrfs and ZFS developers
-------------------------------------------------

I am considering the wisdom of developing a filesystem based on
versioned pointers.  The prospect of per-file and per-directory
versioning seems attractive, as does the elegant formulation of
snapshots-of-snapshots and the compact metadata.  I suspect that less
updating of metadata will be required for writes versus either Btrfs or
ZFS.  Mind you, there is no working filesystem code at the moment, only
ddsnap the snapshotting block device and the attached proof of concept
of versioned pointers, so some of this is speculation.

I described earlier how versioned pointers will be extended to versioned
extents but have not yet tried it.  This would be necessary in order to
operate in the same ballpark of efficiency as ZFS or Btrfs.

Versioned pointers have some advantages over versioning methods used in
ZFS and Btrfs, and also some potential drawbacks:

Advantages versus ZFS and Btrfs:

 * No per-write recursive copy on write of metadata blocks.  Creating a
   new copy of a data block normally only requires inserting a new
   versioned pointer to a btree leaf block.  Such inserts can be logged
   logically and added to the btree in large batches, which can be done
   atomically using standard methods (physical journal, log or copy on
   write).

Advantages versus Btrfs:

 * No reference count updates, which must be be durable and atomic,
   surely a painful overhead.  Instead, it can be determined entirely
   from the exception list whether a given block is referenced, so
   only exception lists need to be updated, and only by adding,
   removing, or in rare cases, relabeling physical pointers.

Advantages versus ZFS:

 * No need to maintain a dead list.  This information can be entirely
   determined from the combination of the versioned pointers and the
   version tree.

 * It would seem that ZFS is deeply wedded to the concept of a single,
   linear chain of snapshots.  No snapshots of snapshots, apparently.
   http://blogs.sun.com/ahrens/entry/is_it_magic

Drawbacks of versioned pointers:

 * All version info stored together for any given logical address.
   This will require reading more metadata blocks as the number of
   versions increases, and put more pressure on cache.  How to fix: with
   extents, metadata is tiny compared to data, even if expanded by a
   large factor, so it may not matter.  If it does, an in-memory version
   of accessed btree nodes for a particular snapshot can be cached and
   saved persistently to disk so that the full version btree only
   rarely needs to be accessed.

 * Delete is a full tree pass over the metadata.  But this can be done
   in the background for multiple deleted versions per pass.  Also can
   keep a persistent cache per version of which logical address ranges
   have exceptions for a given version to limit the search.

 * Limited number of versions.  This can be overcome mindlessly by
   extending the size of a physical pointer, or more elegantly by
   keeping a per-leaf "wide" translation table of versions referenced
   by the leaf, or both depending on which representation is smaller for
   a particular leaf.

--Boundary-00=_eMceIWz5TxQXOjH
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="fuzzversion.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fuzzversion.c"

#include <stdio.h>
#include <inttypes.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>

#define vecmove(d, s, n) memmove(d, s, (n) * sizeof(*(d)))
#define vecset(d, v, n) memset(d, v, (n) * sizeof(*(d)))
#define error(string, args...) do { printf(string "!\n", ##args); exit(99); } while (0)
#define assert(expr) do { if (!(expr)) error("Failed assertion \"%s\"", #expr); } while (0)
#define trace_off(cmd)
#define trace_on(cmd) cmd
#define PACKED __attribute__ ((packed))

#if 1
void hexdump(void *data, unsigned size)
{
	while (size) {
		unsigned char *p;
		int w = 16, n = size < w? size: w, pad = w - n;
		printf("%p:  ", data);
		for (p = data; p < (unsigned char *)data + n;)
			printf("%02hx ", *p++);
		printf("%*.s  \"", pad*3, "");
		for (p = data; p < (unsigned char *)data + n;) {
			int c = *p++;
			printf("%c", c < ' ' || c > 127 ? '.' : c);
		}
		printf("\"\n");
		data += w;
		size -= n;
	}
}
#endif

bool get_bit(unsigned char *bitmap, unsigned i)
{
	return (bitmap[i >> 3] >> (i & 7)) & 1;
}

void set_bit(unsigned char *bitmap, unsigned i)
{
	bitmap[i >> 3] |= (1 << (i & 7));
}

void reset_bit(unsigned char *bitmap, unsigned i)
{
	bitmap[i >> 3] &= ~(1 << (i & 7));
}

#define LABEL_BITS 8
#define CHUNK_BITS 54
#define MAXVERSIONS (1 << LABEL_BITS)

typedef uint16_t version_t;
typedef uint16_t label_t;
typedef uint64_t chunk_t;
typedef unsigned tag_t;

struct exception { label_t label: LABEL_BITS; chunk_t chunk: CHUNK_BITS; } PACKED;
struct version { tag_t tag; label_t parent; bool used, ghost, present, pathmap, nearmap; };

struct version ver[MAXVERSIONS];
label_t *child_index[MAXVERSIONS];
label_t child_count[MAXVERSIONS];
label_t children[MAXVERSIONS];
label_t ordmap[MAXVERSIONS];
label_t version_count, active_count;
unsigned cycle;

label_t get_child(label_t parent, unsigned i)
{
	return child_index[parent][i];
}

label_t get_parent(label_t child)
{
	return ver[child].parent;
}

label_t get_root(void)
{
	assert(child_count[0]);
	return children[0];
}

label_t is_ghost(label_t version)
{
	return ver[version].ghost;
}

int find_tag(tag_t tag)
{
	for (int version = 1; version < version_count; version++)
		if (!is_ghost(version) && ver[version].tag == tag)
			return version;
	error("invalid snapshot '%u'", tag);
	return 0;
}

void show_table(void)
{
	for (int i = 0; i < version_count; i++) {
		printf("%i: ", i);
		if (!ver[i].used)
			printf("(free)");
		else if (!i)
			printf("(origin)");
		else {
			printf("<- ");
			if (!get_parent(i))
				printf("root");
			else
				printf("%i", get_parent(i));
			if (!is_ghost(i)) // 0 should be a ghost
				printf(" '%i'", ver[i].tag);
		}
		printf("\n");
	}
}

int count_table(void)
{
	int total = 0;
	for (int i = 0; i < version_count; i++)
		total += ver[i].used;
	return total;
}

unsigned exceptions;
struct exception excep[1000];

void show_exceptions(void)
{
	printf("%i exceptions: ", exceptions);
	for (int i = 0; i < exceptions; i++)
		printf("[%i, %Lu] ", excep[i].label, (chunk_t)excep[i].chunk);
	printf("\n");
}

void show_index(void)
{
	printf("child index: ");
	for (int i = 0; i < version_count; i++)
		printf("%i:%u ", i, children - child_index[i]);
	printf("\n");
}

int show_subtree(version_t version, int depth, version_t target)
{
	assert(depth < MAXVERSIONS);
	printf("%*s%i: ", 3 * depth, "", version);
	if (!is_ghost(version))
		printf("'%i'", ver[version].tag);
	else printf("~%i", child_count[version]);
	for (int i = 0; i < exceptions; i++)
		if (excep[i].label == version)
			printf(" [%Lu]", (chunk_t)excep[i].chunk);
	printf("%s\n", target == version ? " <==" : "");
	int total = 0;
	for (int i = 0; i < child_count[version]; i++)
		total += show_subtree(get_child(version, i), depth + 1, target);
	return total + 1;
}

void show_tree_with_target(tag_t tag)
{
	version_t target = tag == -1 ? 0 : find_tag(tag);
	int total = child_count[0] ? show_subtree(get_root(), 0, target) : 0;
	printf("%u versions\n", total);
}

void show_tree(void)
{
	show_tree_with_target(-1);
}

int count_subtree(label_t version, int depth)
{
	if (depth > MAXVERSIONS)
		return MAXVERSIONS;
	assert(ver[version].used);
	int total = 0;
	for (int i = 0; i < child_count[version]; i++)
		total += count_subtree(get_child(version, i), depth + 1);
	return total + 1;
}

int count_tree(void)
{
	return count_subtree(0, 0);
}

void order_tree(label_t version, int order)
{
	ordmap[version] = order;
	for (int i = 0; i < child_count[version]; i++)
		order_tree(get_child(version, i), order + 1);
}

/* Chunk allocation */

#define MAXCHUNKS MAXVERSIONS

typedef unsigned data_t;

chunk_t nextchunk;
data_t snapdata[MAXCHUNKS], orgdata = 0x1234;
data_t checkdata[MAXVERSIONS];
bool allocmap[MAXCHUNKS];

chunk_t new_chunk(data_t data)
{
	for (int i = 0; i < MAXCHUNKS; i++, nextchunk++) {
		if (nextchunk == MAXCHUNKS)
			nextchunk = 0;
		if (!allocmap[nextchunk])
			goto found;
	}
	error("out of chunks");
found:
	assert(!allocmap[nextchunk]);
	allocmap[nextchunk] = 1;
	snapdata[nextchunk] = data;
	return nextchunk++;

}

void free_chunk(chunk_t chunk)
{
	assert(allocmap[chunk]);
	allocmap[chunk] = 0;
}

/* Version allocation */

label_t new_version(label_t parent, uint32_t tag)
{
	int version;
	for (version = 1; version < version_count; version++)
		if (!ver[version].used)
			goto recycle;
	int last = version_count - 1;
	child_index[version_count] = version_count ? child_index[last] + child_count[last] : children;
	version = version_count++;
recycle:
	ver[version] = (struct version){ .parent = parent, .tag = tag, .used = 1 };
	assert(!child_count[version]);
	active_count++;
	return version;
}

void free_version(label_t version)
{
	assert(ver[version].used);
	ver[version].parent = 0;
	ver[version].used = 0;
	active_count--;
}

/* Version tree editing */

void add_exception(label_t label, chunk_t chunk)
{
	printf("new exception [%u, %Lu]\n", label, chunk);
	assert(exceptions < MAXVERSIONS);
	excep[exceptions++] = (struct exception){ .label = label, .chunk = chunk };
}

unsigned char pathmap[MAXVERSIONS][MAXVERSIONS >> 3];
unsigned char nearmap[MAXVERSIONS][MAXVERSIONS >> 3];

/*
 * Store the ord numbers in the version table.  Per-version bitmap specifies
 * whether any given version is on the path to root.  Walk the exception list
 * looking for the label on the path with the highest ord.
 */
struct exception *lookup_chunk(label_t target)
{
	if (!ver[target].pathmap) {
		trace_off(printf("load pathmap for %u \n", target);)
		memset(pathmap[target], 0, sizeof(pathmap[target]));
		for (label_t v = target; v; v = get_parent(v))
			set_bit(pathmap[target], v);
		ver[target].pathmap = 1;
	}
	int high = 0;
	unsigned char *path = pathmap[target];
	struct exception *found = NULL;
	for (struct exception *e = excep; e < excep + exceptions; e++)
		if (get_bit(path, e->label) && ordmap[e->label] > high)
			high = ordmap[(found = e)->label];
	return found;
}


unsigned count_near(label_t target)
{
	if (!ver[target].nearmap) {
		trace_off(printf("load nearmap for %u \n", target);)
		memset(nearmap[target], 0, sizeof(nearmap[target]));
		for (int i = 0; i < child_count[target]; i++)
			set_bit(nearmap[target], get_child(target, i));
		set_bit(nearmap[target], target);
		ver[target].nearmap = 1;
	}
	unsigned char *map = nearmap[target];
	int present = 0;
	for (struct exception *e = excep; e < excep + exceptions; e++)
		present += get_bit(map, e->label);
	assert(present <= child_count[target] + 1);
	return present;
}

struct exception *find_exception(label_t target)
{
	for (int i = 0; i < exceptions; i++)
		if (excep[i].label == target)
			return &excep[i];
	return NULL;
}

void set_present(bool flag)
{
	for (struct exception *e = excep; e < excep + exceptions; e++)
		ver[e->label].present = flag;
}

bool is_present(version_t version)
{
	return ver[version].present;
}

int count_heirs(label_t version)
{
	int heirs = 0;
	for (int i = 0; i < child_count[version]; i++) {
		version_t child = get_child(version, i);
		if (!is_present(child))
			heirs += count_heirs(child) + !is_ghost(child);
	}
	return heirs;
}

/*
 * O(exceptions) orphan test
 *
 * The orphan test is used in snapshot write and exception delete to identify
 * any new orphans created as a result of a write that creates an exclusive
 * exception for the only heir of the ghost exception, or a delete that removes
 * the only heir and does not promote a new heir.
 *
 * The current method of determining whether a ghost exception is an orphan is
 * to recurse through the subtree below the ghost until a visible version is
 * found that inherits the exception.  This test runs in O(versions) time.
 *
 * To perform this test in O(exceptions) time, we proceed as follows.
 *
 * Identify a subtree of the version tree consisting only of subtrees consisting
 * only of ghost versions in interior nodes and visible versions at the terminal
 * nodes, descending from the ghost ancestor of the victim version nearest the
 * root and not having any visible versions or present exceptions between itself
 * and the victim.  Call each node of that subtree a "nexus".  The interesting
 * question is whether any path from the ghost exception reaches a visible version
 * with no exception.  If not, then the ghost exception is an orphan that must be
 * deleted.
 *
 * This can be computed efficiently using a bottom up approach with a single pass
 * through the exception list.  At each nexus keep a count of the children of the
 * nexus that are known not to inherit from that nexus.  Call that the blocked
 * count.  Now:
 *
 * For each exception in the exception list
 *    If the version labeled by the exception is a nexus then increment the
 *    blocked count of the nexus
 *
 *    If the blocked count is now equal to the number of children of the nexus
 *    then repeat from the preceding step
 *
 * At completion, if the blocked count of the ghost ancestor is equal to its child
 * count, the ghost exception is an orphan.
 *
 * Not yet implemented.
 */

int inherited(version_t version)
{
	set_present(1);
	int heirs = count_heirs(version);
	set_present(0);
	//printf("version %i exception has %i heirs\n", version, heirs);
	return heirs;
}

label_t *find_child_pos(label_t parent, label_t child, unsigned count)
{
	/* insert sorted for cosmetic reasons */
	label_t *p = child_index[parent];
	for (int i = 0; i < count; i++, p++)
		if (child < *p)
			break;
	return p;
}

label_t *find_child(label_t parent, label_t child)
{
	for (int i = 0; i < child_count[parent]; i++)
		if (get_child(parent, i) == child)
			return child_index[parent] + i;
	error("child not found");
}

void insert_child(label_t parent, label_t child)
{
	label_t *p = find_child_pos(parent, child, child_count[parent]);
	vecmove(p + 1, p, children + version_count - p - 1);
	*p = child;
	for (int i = parent + 1; i < version_count; i++)
		child_index[i]++;
	child_count[parent]++;
	ver[child].parent = parent;
	ver[parent].nearmap = 0;
	order_tree(get_root(), 1); // overkill
}

void remove_child(label_t child)
{
	label_t parent = get_parent(child);
	label_t *p = find_child(parent, child);
	vecmove(p, p + 1, children + version_count - p - 1);
	for (int i = parent + 1; i < version_count; i++)
		child_index[i]--;
	child_count[parent]--;
	ver[parent].nearmap = 0;
}

void replace_child(label_t child, label_t newchild)
{
	version_t parent = get_parent(child);
	version_t *p1 = child_index[parent], *p2 = find_child(parent, child);
	vecmove(p2, p2 + 1, p1 + child_count[parent] - p2 - 1);
	p2 = find_child_pos(parent, newchild, child_count[parent] - 1);
	vecmove(p2 + 1, p2, p1 + child_count[parent] - p2 - 1);
	*p2 = newchild;
	ver[newchild].parent = parent;
	free_version(child);
	ver[parent].nearmap = 0;
}

void invalidate_path(version_t version)
{
	assert(version < MAXVERSIONS);
	assert(ver[version].used);
	ver[version].pathmap = 0;
	for (int i = 0; i < child_count[version]; i++)
		invalidate_path(get_child(version, i));
}

void promote_child(label_t child)
{
	version_t parent = get_parent(child);
	printf("promote version %u to child of %u \n", child, parent);
	assert(child_count[parent] == 1);
	remove_child(child);
	replace_child(parent, child);
	invalidate_path(child);
	order_tree(get_root(), 1); // overkill
}

void extract_children(void) // O(n^2)
{
	unsigned total = 0;
	memset(child_count, 0, sizeof child_count);
	for (int parent = 0; parent < version_count; parent++) {
		child_index[parent] = children + total;
		for (int child = 0; child < version_count; child++)
			if (get_parent(child) == parent) {
				children[total++] = child;
				child_count[parent]++;
			}
	}
}

/*
 * Three pass O(versions) tree extract
 *
 * 1: walk the table incrementing child counts of nonfree parents
 * 2: accumlate the counts to create the index, clear the counts
 * 3: walk the table filling in the children using the index
 */
void extract_children_fast_untested(void) // O(n^2)
{
	unsigned total = 0;
	vecset(child_count, 0, version_count);
	for (int i = 0; i < version_count; i++)
		if (ver[i].used)
			child_count[get_parent(i)]++;
	for (int i = 0; i < version_count; i++) {
		child_index[i] = children + total;
		total += child_count[i];
	}
	vecset(child_count, 0, version_count);
	for (int i = 0; i < version_count; i++)
		if (ver[i].used) {
			version_t parent = get_parent(i);
			child_index[parent][child_count[parent]++] = i;
		}
}

/*
 * O(exceptions) exception delete
 *
 * 1: walk the exception list incrementing per parent present child counts
 * 2: walk the list deleting target exceptions where present equals child count
 * 3: walk the list clearing present entries for the next time round
 */
label_t brood[MAXVERSIONS]; /* children present in exception list per parent */

bool delete_exceptions(version_t target, version_t parent)
{
	printf("delete target %u, parent %i, %i children\n", target, parent, child_count[target]);
	struct exception *limit = excep + exceptions, *save = excep, *kill = NULL;
	for (struct exception *from = excep; from < limit; from++)
		brood[get_parent(from->label)]++;
	set_present(1);
	if (!is_present(target)) {
		/* kill orphans */
		version_t ancestor = parent;
		while (!is_present(ancestor) && ancestor)
			ancestor = get_parent(ancestor);
		if (ancestor && is_ghost(ancestor) && is_present(ancestor) && !count_heirs(ancestor))
			kill = find_exception(ancestor);
	}
	if (kill)
		printf("kill orphan %u\n", kill->label);
	if (!is_ghost(parent))
		parent = 0;
	for (struct exception *from = excep; from < limit; from++) {
		if (from == kill)
			goto free;
		version_t label = from->label;
		if (label == target || label == parent) {
			if (child_count[label] == brood[label])
				goto free;
			if (child_count[label] == 1) {
				if (!count_heirs(label))
					goto free;
				printf("relabel %i as %i\n", label, get_child(label, 0));
				ver[label].present = 0;
				label = from->label = get_child(label, 0);
				ver[label].present = 1;
				goto keep;
			}
			if (child_count[label] > 1 && !count_heirs(label))
				goto free;
			goto keep;
		}
keep:
		*save++ = *from;
		continue;
free:
		ver[label].present = 0;
		printf("free [%i, %Li]\n", from->label, (chunk_t)from->chunk);
		free_chunk(from->chunk);
		exceptions--;
	}
	set_present(0);
	for (save = excep; save < excep + exceptions; save++)
		brood[get_parent(save->label)] = 0;
	return parent && child_count[parent] == 1;
}

/* External operations */

void snapshot_delete(tag_t tag)
{
	//if (cycle == 75109) show_tree_with_target(tag);
	version_t target = find_tag(tag);
	memset(brood, 0, sizeof(brood));
	ver[target].tag = 0;
	ver[target].ghost = 1; /* does not inherit ghost exception */
	version_t parent = get_parent(target);
	switch (child_count[target]) {
	case 0:
		remove_child(target); /* no relabel to deleted child */
		free_version(target);
		if (delete_exceptions(target, parent))
			promote_child(get_child(parent, 0));
		break;
	case 1:
		delete_exceptions(target, parent);
		promote_child(get_child(target, 0));
		break;
	default:
		delete_exceptions(target, parent);
	}
}
/*
 * Ghost exception inheritance
 *
 * Any ghost exception inherited only by ghosts may be deleted.
 *
 * If a target with more than one child, an exception and no heirs is deleted
 * then the exception may be deleted.
 *
 * Replacing a target with one child and no exception by its child with no
 * heirs reduces heirs of the parent.
 *
 * If a target has no children and no exception then removing it or replacing
 * its ghost parent with no exception by a sibling of the target with no
 * heirs reduces heirs of the parent.
 *
 * If heirs are reduced, a search for a ghost ancestor with an uninherited
 * exception must be performed.
 */

void snapshot_of_snapshot(tag_t tag, tag_t parent_tag)
{
	label_t parent = find_tag(parent_tag);
	label_t child = new_version(parent, tag);
	assert(!child_count[child]);
	insert_child(parent, child);
	order_tree(get_root(), 1); // overkill
}

void snapshot_of_origin(tag_t tag)
{
	label_t root = new_version(0, tag);
	if (!child_count[0]) {
		insert_child(0, root);
		return;
	}
	insert_child(root, get_child(0, 0));
	children[0] = root;
	invalidate_path(root);
	order_tree(get_root(), 1); // overkill
}

data_t snapshot_read(tag_t tag)
{
	struct exception *found = lookup_chunk(find_tag(tag));
	//printf("read version %u, chunk %Li \n", find_tag(tag), found->chunk);
	return found ? snapdata[found->chunk] : orgdata;
}

void snapshot_write(tag_t tag, data_t data)
{
	label_t target = find_tag(tag);
	printf("write 0x%x to snapshot %i version %u \n", data, tag, target);
	struct exception *e;

	/* has unique exception? */
	if (count_near(target) == child_count[target] + 1) {
		e = find_exception(target);
		goto rewrite;
	}

	/* create implicit version? */
	if (child_count[target]) {
		label_t child = new_version(target, tag);
		printf("implicit version %u of %u \n", child, target);
		insert_child(target, child);
		ver[target].ghost = 1;
		target = child;
	}

	/* relabel orphan? */
	set_present(1);
	label_t ancestor = get_parent(target);
	while (!is_present(ancestor) && is_ghost(ancestor))
		ancestor = get_parent(ancestor);
	bool relabel = is_ghost(ancestor) && count_heirs(ancestor) == 1;
	set_present(0);
	if (relabel) {
		printf("relabel version %u exception to %u!\n", ancestor, target);
		e = find_exception(ancestor);
		e->label = target;
		goto rewrite;
	}

	/* new exception */
	chunk_t chunk = new_chunk(data);
	add_exception(target, chunk);
	checkdata[target] = snapdata[chunk] = data;
	return;
rewrite:
	printf("rewrite chunk %Lu to 0x%x\n", (chunk_t)e->chunk, data);
	checkdata[target] = snapdata[e->chunk] = data;
	return;
}

void origin_write(data_t data)
{
	printf("write 0x%x to origin\n", data);
	if (child_count[0] && !find_exception(get_root()))
		add_exception(get_root(), new_chunk(orgdata));
	orgdata = data;
}

void fuzztest(int cycles)
{
	tag_t snap[MAXVERSIONS], tag, newtag = 1000;
	int snaps = 0;
	char *why;

	for (cycle = 1; cycle <= cycles; cycle++) {
		printf("--- cycle %i ---\n", cycle);
		if (!snaps || rand() % 5 == 0) {
			if (!snaps || (snaps < MAXVERSIONS / 2 && rand() % 2000000 < 1000000)) {
				/* Randomly create snapshot */
				tag = snap[snaps] = newtag++;
				if (!snaps || rand() % 20 == 0) {
					printf("create snapshot %u of origin\n", tag);
					snapshot_of_origin(tag);
					checkdata[find_tag(tag)] = orgdata;
				} else {
					tag_t parent = snap[rand() % snaps];
					printf("create snapshot %u of %u \n", tag, parent);
					snapshot_of_snapshot(tag, parent);
					checkdata[find_tag(tag)] = snapshot_read(parent);
				}
				snaps++;
			} else {
				/* Randomly delete snapshot */
				int which = rand() % snaps;
				printf("delete snapshot %u \n", snap[which]);
				delete_snapshot(snap[which]);
				snap[which] = snap[--snaps];
			}
		} else {
			/* Write to random snapshot */
			data_t data = rand();
			if (rand() % 20 == 0) {
				tag = -1;
				origin_write(data);
			} else {
				tag = snap[rand() % snaps];
				snapshot_write(tag, data);
			}
		}
continue;
		/* Validate version table */
		why = "version 0 corrupted";
		if (is_ghost(0) || child_count[0] > 1)
			goto eek;
		for (int version = 0; version < version_count; version++) {
			why = "present flag should be clear";
			if (ver[version].present) {
				printf("present flag should be clear for %u\n", version);
				goto eek;
			}
			why = "ghost has less than two children";
			if (is_ghost(version) && child_count[version] < 2) {
				printf("ghost %i has less than two children\n", version);
				goto eek;
			}
		}
		/* Validate version tree */
		why = "tree has a cycle";
		int counted = count_tree();
		if (counted == MAXVERSIONS)
			goto eek;
		why = "wrong number of versions in version tree";
		if (counted != active_count)
			goto eek;
		/* Validate exception list */
		bool member[MAXVERSIONS] = { };
		for (int i = 0; i < exceptions; i++) {
			label_t version = excep[i].label;
			//printf("[%i, %Lu]\n", version, (chunk_t)excep[i].chunk);
			why = "invalid exception label";
			if (version == 0 || version > MAXVERSIONS)
				goto eek;
			why = "deleted version in exception list";
			if (!ver[version].used)
				goto eek;
			why = "multiple exceptions with same label";
			if (member[version])
				goto eek;
			why = "ghost has orphan exception";
			if (is_ghost(version) && !inherited(version)) {
				printf("ghost %i has orphan exception\n", version);
				goto eek;
			}
			member[version] = 1;
		}
		/* Validate snapshot data */
		why = "snapshot has wrong data";
		for (int i = 0; i < snaps; i++) {
			data_t data = snapshot_read(snap[i]);
			if (data != checkdata[find_tag(snap[i])]) {
				printf("snapshot %u has wrong data 0x%x\n", snap[i], data);
				tag = snap[i];
				goto eek;
			}
		}
		//if (cycle == 75109) { show_tree(); exit(1); }
	}
	show_tree();
	show_exceptions();
	return;
eek:
	printf("--- Failed at cycle %u --- \n", cycle);
	show_tree_with_target(tag);
	//show_table();
	printf("tree count = %u, table count = %u, active count = %u\n", count_tree(), count_table(), active_count);
	show_exceptions();
	error("%s", why);
}

int main(void)
{
	label_t v0 = new_version(-1, 0);

#if 1
	srand(12345);
	fuzztest(20000000);
	return 0;
#endif

	tag_t nexttag = 1001;
	label_t v1 = v1 = new_version(v0, nexttag++);
	label_t v2 = v2 = new_version(v1, nexttag++);
	label_t v3 = v3 = new_version(v2, nexttag++);
#if 0
	show_table();
	extract_children();
	show_tree();
	hexdump(child_count, 16);
	hexdump(child_index, 16);
	hexdump(children, 16);
	promote_child(v3);
	//remove_version(v5);
	//delete_snapshot(2000);
	//nested_snapshot(123, 2005);
	//snapshot_of_origin(123);
	show_table();
	hexdump(child_count, 16);
	hexdump(child_index, 16);
	hexdump(children, 16);
	show_tree();
	extract_children();
	show_tree();
	return 0;
	free_version(v1);
	free_version(v4);
	show_table();
	return 0;
#endif
	extract_children();
	label_t target = v2;
	tag_t tag = ver[target].tag;
	add_exception(v2, new_chunk(0));
	show_exceptions();
	show_tree();
	printf("data = %u\n", snapshot_read(tag));
	snapshot_write(tag, 0x333);
	show_tree();
	snapshot_write(1003, 0x666);
	show_tree();
//	hexdump(snapdata, 16);
//	origin_write(666);
//	origin_write(777);
//	snapshot_write(ver[target].tag, 555);
	show_exceptions();
	hexdump(snapdata, 32);
	printf("data = 0x%x, orgdata = 0x%x\n", snapshot_read(tag), orgdata);
	printf("v3 data = 0x%x\n", snapshot_read(ver[v3].tag));
	show_tree();
	hexdump(nearmap[v2], 16);
//	delete_exceptions((label_t[]){ v7 }, 1);
	delete_snapshot(1003);
	show_tree();
	show_exceptions();
	delete_snapshot(1001);
	show_tree();
	show_exceptions();
	delete_snapshot(1002);
	show_tree();
	show_exceptions();
	snapshot_of_origin(1009);
	show_tree();
	show_exceptions();
	printf("data = 0x%x, orgdata = 0x%x\n", snapshot_read(1002), orgdata);
	hexdump(child_index, 16);
	return 0;

	label_t v4 = v4 = new_version(v1, nexttag++);
	label_t v5 = v5 = new_version(v4, nexttag++);
	label_t v6 = v6 = new_version(v4, nexttag++);
	add_exception(v5, new_chunk(0));
	add_exception(v6, new_chunk(0));
#if 0
	load_nearmap(v4);
	hexdump(nearmap[v4], 16);
	return 0;
#endif

	return 0;
}

--Boundary-00=_eMceIWz5TxQXOjH--
